#!/usr/bin/env python3
"""
job_content_scanner.py - Scan job listings for prompt injection patterns

Usage:
  python job_content_scanner.py <file_path>
  echo "content" | python job_content_scanner.py --stdin

Returns: JSON with {safe: bool, recommendation: str, matches: []}
Exit codes: 0 = safe, 1 = unsafe, 2 = error
"""

import sys
import re
import json
import unicodedata
import base64
from pathlib import Path
from datetime import datetime, timezone

# Prompt injection patterns to detect
# Each pattern uses word boundaries and is case-insensitive
INJECTION_PATTERNS = [
    # Direct instruction overrides (most common attack vector)
    (r'\bignore\s+(all\s+)?(previous|prior|above|earlier|preceding)\s+(instructions?|prompts?|directives?|rules?|guidelines?)\b', 'instruction_override'),
    (r'\bdisregard\s+(all\s+)?(previous|prior|above|earlier|preceding)\s+(instructions?|prompts?|directives?|rules?|guidelines?)\b', 'instruction_override'),
    (r'\bforget\s+(all\s+)?(your\s+)?(previous|prior|earlier)?\s*(instructions?|prompts?|directives?|rules?|guidelines?)\b', 'instruction_override'),
    (r'\boverride\s+(your|all|previous|the)\s+(instructions?|prompts?|directives?|rules?|guidelines?)\b', 'instruction_override'),
    (r'\bnew\s+instructions?\s*:', 'instruction_override'),
    (r'\bupdated?\s+instructions?\s*:', 'instruction_override'),
    (r'\bsystem\s+prompt\s*:', 'instruction_override'),
    (r'\boriginal\s+instructions?\s*:', 'instruction_override'),

    # Role hijacking attempts (more specific to avoid false positives)
    # "You are now a/an [adjective]? [role]" - require a role-like word (possibly after adjectives)
    (r'\byou\s+are\s+now\s+(a|an)\s+(\w+\s+)*(assistant|ai|bot|model|helper|agent)\b', 'role_hijack'),
    # "From now on, you/your" followed by behavior change
    (r'\bfrom\s+now\s+on,?\s+(you|your)\s+(will|must|should|are|have)\b', 'role_hijack'),
    # "Act as if you are" - specific phrasing
    (r'\bact\s+as\s+if\s+you\s+(are|were)\b', 'role_hijack'),
    # "Act as a/an [AI-related role]"
    (r'\bact\s+as\s+(a|an)\s+\w*(assistant|ai|bot|model|helper|agent|system)\b', 'role_hijack'),
    (r'\bpretend\s+(you\s+are|to\s+be|you\'re)\b', 'role_hijack'),
    (r'\byour\s+new\s+role\s+(is|will\s+be)\b', 'role_hijack'),
    (r'\bswitch\s+(to|into)\s+(a\s+)?new\s+mode\b', 'role_hijack'),
    (r'\benter\s+(a\s+)?new\s+mode\b', 'role_hijack'),
    (r'\byou\s+must\s+now\s+(act|behave|respond|follow|obey)\b', 'role_hijack'),

    # Delimiter/format attacks
    (r'```\s*(system|instructions?|prompt|admin)', 'delimiter_attack'),
    (r'---+\s*BEGIN\s*(NEW\s*)?(PROMPT|INSTRUCTIONS?|SYSTEM)', 'delimiter_attack'),
    (r'---+\s*END\s*(OF\s*)?(PROMPT|INSTRUCTIONS?|SYSTEM)', 'delimiter_attack'),
    (r'<\/?(system|instructions?|prompt|admin)>', 'delimiter_attack'),
    (r'\[/?INST\]', 'delimiter_attack'),
    (r'\[/?SYS(TEM)?\]', 'delimiter_attack'),
    (r'<\|im_(start|end)\|>', 'delimiter_attack'),

    # Authority/privilege escalation claims
    (r'\badmin(istrator)?\s+(override|mode|access)\b', 'authority_claim'),
    (r'\bthe\s+user\s+has\s+(authorized|approved|granted)\b', 'authority_claim'),
    (r'\bfor\s+(security\s+)?testing\s+purposes?\b', 'authority_claim'),
    (r'\bemergency\s+(override|mode|access)\b', 'authority_claim'),
    (r'\bdeveloper\s+mode\s+(enabled|on|activated)\b', 'authority_claim'),
    (r'\bdebug\s+mode\s+(enabled|on|activated)\b', 'authority_claim'),
    (r'\bjailbreak\b', 'authority_claim'),
    (r'\bdan\s+mode\b', 'authority_claim'),

    # Conversation injection (Claude/ChatGPT specific)
    (r'^Human\s*:', 'conversation_injection'),
    (r'^Assistant\s*:', 'conversation_injection'),
    (r'^System\s*:', 'conversation_injection'),
    (r'^User\s*:', 'conversation_injection'),
    (r'^AI\s*:', 'conversation_injection'),

    # Output manipulation
    (r'\bprint\s+(only|just)\s+(the\s+)?(following|this)\b', 'output_manipulation'),
    (r'\brespond\s+(only\s+)?with\b', 'output_manipulation'),
    (r'\boutput\s+(only|just)\b', 'output_manipulation'),
    (r'\bsay\s+(only|just|exactly)\b', 'output_manipulation'),
]

# Suspicious but not definitive patterns (logged but don't trigger unsafe)
SUSPICIOUS_PATTERNS = [
    (r'\bprompt\s+injection\b', 'meta_reference'),
    (r'\bsystem\s+prompt\b', 'meta_reference'),
    (r'\bhidden\s+(text|instructions?|prompt)\b', 'hidden_content'),
    (r'\binvisible\s+(text|instructions?)\b', 'hidden_content'),
]


def normalize_text(text: str) -> str:
    """
    Normalize unicode and whitespace for consistent pattern matching.

    - NFKC normalization converts lookalike characters (Cyrillic а → Latin a)
    - Collapses multiple whitespace to single space
    - Preserves newlines for line-start patterns
    """
    # NFKC normalization
    text = unicodedata.normalize('NFKC', text)
    # Collapse multiple spaces/tabs (but preserve newlines for ^ patterns)
    text = re.sub(r'[^\S\n]+', ' ', text)
    # Collapse multiple newlines
    text = re.sub(r'\n{3,}', '\n\n', text)
    return text


def scan_for_patterns(text: str) -> list[dict]:
    """
    Scan text for injection patterns.

    Returns list of match dictionaries with pattern, category, matched text, and position.
    """
    normalized = normalize_text(text)
    matches = []

    for pattern, category in INJECTION_PATTERNS:
        for match in re.finditer(pattern, normalized, re.IGNORECASE | re.MULTILINE):
            matches.append({
                'pattern': pattern[:50] + '...' if len(pattern) > 50 else pattern,
                'category': category,
                'matched_text': match.group(0),
                'position': match.start(),
                'severity': 'high'
            })

    return matches


def scan_for_suspicious(text: str) -> list[dict]:
    """
    Scan for suspicious but not definitive patterns.
    These are logged but don't trigger unsafe status.
    """
    normalized = normalize_text(text)
    matches = []

    for pattern, category in SUSPICIOUS_PATTERNS:
        for match in re.finditer(pattern, normalized, re.IGNORECASE | re.MULTILINE):
            matches.append({
                'pattern': pattern,
                'category': category,
                'matched_text': match.group(0),
                'position': match.start(),
                'severity': 'low'
            })

    return matches


def scan_base64_content(text: str) -> list[dict]:
    """
    Check for base64-encoded injection attempts.

    Looks for long base64 strings, decodes them, and scans the decoded content.
    """
    # Look for suspiciously long base64 strings (40+ chars)
    b64_pattern = r'[A-Za-z0-9+/]{40,}={0,2}'
    matches = []

    for match in re.finditer(b64_pattern, text):
        try:
            # Attempt to decode
            decoded = base64.b64decode(match.group()).decode('utf-8', errors='ignore')

            # Only check if decoded content is readable (mostly ASCII)
            if len(decoded) > 10 and sum(c.isalnum() or c.isspace() for c in decoded) / len(decoded) > 0.7:
                # Scan decoded content for injection patterns
                nested_matches = scan_for_patterns(decoded)
                if nested_matches:
                    matches.append({
                        'pattern': 'base64_encoded_injection',
                        'category': 'encoded_attack',
                        'matched_text': f"{match.group()[:30]}... (decoded: {decoded[:40]}...)",
                        'position': match.start(),
                        'severity': 'high',
                        'decoded_content': decoded[:100]
                    })
        except Exception:
            pass  # Not valid base64 or not decodable, ignore

    return matches


def scan_content(text: str) -> dict:
    """
    Main scanning function.

    Returns:
        {
            'safe': bool,
            'recommendation': 'process' | 'quarantine',
            'matches': list of high-severity matches,
            'suspicious': list of low-severity matches,
            'match_count': int,
            'scanned_length': int
        }
    """
    results = {
        'safe': True,
        'recommendation': 'process',
        'matches': [],
        'suspicious': [],
        'match_count': 0,
        'scanned_length': len(text),
        'timestamp': datetime.now(timezone.utc).isoformat()
    }

    # Scan for high-severity injection patterns
    high_severity = scan_for_patterns(text)
    results['matches'].extend(high_severity)

    # Scan for encoded content
    encoded_matches = scan_base64_content(text)
    results['matches'].extend(encoded_matches)

    # Scan for suspicious (but not definitive) patterns
    suspicious = scan_for_suspicious(text)
    results['suspicious'].extend(suspicious)

    # Determine safety
    results['match_count'] = len(results['matches'])
    if results['match_count'] > 0:
        results['safe'] = False
        results['recommendation'] = 'quarantine'

    return results


def log_to_flagged(file_path: str, results: dict, jobs_dir: Path) -> None:
    """
    Log flagged content to the quarantine flagged.jsonl file.
    """
    flagged_log = jobs_dir / 'quarantine' / 'flagged.jsonl'
    flagged_log.parent.mkdir(parents=True, exist_ok=True)

    log_entry = {
        'timestamp': results['timestamp'],
        'file': str(file_path),
        'match_count': results['match_count'],
        'categories': list(set(m['category'] for m in results['matches'])),
        'matched_texts': [m['matched_text'] for m in results['matches'][:5]],  # First 5 only
        'recommendation': results['recommendation']
    }

    with open(flagged_log, 'a') as f:
        f.write(json.dumps(log_entry) + '\n')


def main():
    # Handle --stdin flag
    if len(sys.argv) == 2 and sys.argv[1] == '--stdin':
        content = sys.stdin.read()
        file_path = '<stdin>'
    elif len(sys.argv) == 2:
        file_path = sys.argv[1]
        path = Path(file_path)

        if not path.exists():
            print(json.dumps({'error': f'File not found: {file_path}', 'safe': False}))
            sys.exit(2)

        try:
            content = path.read_text(encoding='utf-8')
        except Exception as e:
            print(json.dumps({'error': f'Failed to read file: {str(e)}', 'safe': False}))
            sys.exit(2)
    else:
        print(json.dumps({'error': 'Usage: python job_content_scanner.py <file_path> | --stdin'}))
        sys.exit(2)

    # Scan content
    results = scan_content(content)
    results['file'] = file_path

    # Log if unsafe
    if not results['safe'] and file_path != '<stdin>':
        # Try to find jobs directory (look for jobs/quarantine relative to file or cwd)
        file_parent = Path(file_path).parent if file_path != '<stdin>' else Path.cwd()

        # Look for jobs directory
        for search_path in [file_parent, file_parent.parent, Path.cwd()]:
            jobs_dir = search_path / 'jobs'
            if jobs_dir.exists():
                log_to_flagged(file_path, results, jobs_dir)
                break

    # Output results
    print(json.dumps(results, indent=2, default=str))

    # Exit with appropriate code
    sys.exit(0 if results['safe'] else 1)


if __name__ == '__main__':
    main()
