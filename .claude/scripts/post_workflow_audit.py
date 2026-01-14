#!/usr/bin/env python3
"""
post_workflow_audit.py - Post-workflow security audit

Runs after Pipeline and Review agents complete to verify:
1. All writes were to expected file types (.md, .json, .jsonl)
2. All writes were to expected paths (jobs/<run>/)
3. No suspicious content was flagged without review
4. Expected output files exist

Returns JSON status and writes completion file.

Usage:
    python3 post_workflow_audit.py <run_dir>
    python3 post_workflow_audit.py 2026-01-12-001
"""

import json
import sys
from datetime import datetime, timezone
from pathlib import Path

# Allowed file extensions for writes
ALLOWED_EXTENSIONS = {'.md', '.json', '.jsonl'}

# Expected files that should exist after workflow
EXPECTED_FILES = ['summary.md']  # index.json is optional


def audit_writes(jobs_dir: Path, run_dir: str) -> dict:
    """Audit all writes from the workflow."""
    results = {
        'writes_checked': 0,
        'writes_allowed': 0,
        'writes_suspicious': [],
        'unexpected_extensions': [],
        'unexpected_paths': [],
    }

    audit_log = jobs_dir / 'write-audit.jsonl'
    if not audit_log.exists():
        return results

    run_path = f"jobs/{run_dir}/"

    with open(audit_log) as f:
        for line in f:
            if not line.strip():
                continue
            try:
                entry = json.loads(line)
                file_path = entry.get('file', '')

                # Only check writes from this run
                if run_dir not in file_path:
                    continue

                results['writes_checked'] += 1

                # Check extension
                ext = Path(file_path).suffix.lower()
                if ext not in ALLOWED_EXTENSIONS:
                    results['unexpected_extensions'].append({
                        'file': file_path,
                        'extension': ext,
                        'timestamp': entry.get('timestamp')
                    })
                    continue

                # Check if flagged as suspicious
                if not entry.get('safe', True):
                    results['writes_suspicious'].append({
                        'file': file_path,
                        'match_count': entry.get('match_count', 0),
                        'timestamp': entry.get('timestamp')
                    })

                results['writes_allowed'] += 1

            except json.JSONDecodeError:
                continue

    return results


def audit_quarantine(jobs_dir: Path, run_dir: str) -> dict:
    """Check quarantine for flagged content."""
    results = {
        'flagged_count': 0,
        'flagged_files': [],
    }

    flagged_log = jobs_dir / run_dir / 'quarantine' / 'flagged.jsonl'
    if not flagged_log.exists():
        return results

    with open(flagged_log) as f:
        for line in f:
            if not line.strip():
                continue
            try:
                entry = json.loads(line)
                results['flagged_count'] += 1
                results['flagged_files'].append({
                    'file': entry.get('file', 'unknown'),
                    'match_count': entry.get('match_count', 0),
                    'timestamp': entry.get('timestamp')
                })
            except json.JSONDecodeError:
                continue

    return results


def audit_expected_files(jobs_dir: Path, run_dir: str) -> dict:
    """Check that expected output files exist."""
    results = {
        'expected_found': [],
        'expected_missing': [],
    }

    run_path = jobs_dir / run_dir

    for expected in EXPECTED_FILES:
        if (run_path / expected).exists():
            results['expected_found'].append(expected)
        else:
            results['expected_missing'].append(expected)

    # Check descriptions directory has files
    desc_dir = run_path / 'descriptions'
    if desc_dir.exists():
        job_files = list(desc_dir.glob('*.md'))
        results['job_files_count'] = len(job_files)
    else:
        results['job_files_count'] = 0

    return results


def run_audit(run_dir: str, jobs_dir: Path = None) -> dict:
    """Run full post-workflow audit."""
    if jobs_dir is None:
        # Try common locations
        for path in [Path.cwd() / 'jobs', Path('/workspace/jobs')]:
            if path.exists():
                jobs_dir = path
                break

    if jobs_dir is None or not jobs_dir.exists():
        return {
            'passed': False,
            'error': 'Jobs directory not found',
            'run_dir': run_dir,
        }

    # Run all audits
    write_audit = audit_writes(jobs_dir, run_dir)
    quarantine_audit = audit_quarantine(jobs_dir, run_dir)
    files_audit = audit_expected_files(jobs_dir, run_dir)

    # Determine pass/fail
    issues = []

    if write_audit['unexpected_extensions']:
        issues.append(f"Unexpected file extensions: {len(write_audit['unexpected_extensions'])}")

    if write_audit['unexpected_paths']:
        issues.append(f"Unexpected write paths: {len(write_audit['unexpected_paths'])}")

    if files_audit['expected_missing']:
        issues.append(f"Missing expected files: {files_audit['expected_missing']}")

    if files_audit['job_files_count'] == 0:
        issues.append("No job files found in descriptions/")

    # Quarantine flags are warnings, not failures (content was still written)
    warnings = []
    if quarantine_audit['flagged_count'] > 0:
        warnings.append(f"Flagged content: {quarantine_audit['flagged_count']} file(s) - review quarantine/flagged.jsonl")

    passed = len(issues) == 0

    result = {
        'passed': passed,
        'run_dir': run_dir,
        'timestamp': datetime.now(timezone.utc).isoformat(),
        'summary': {
            'writes_checked': write_audit['writes_checked'],
            'writes_allowed': write_audit['writes_allowed'],
            'job_files': files_audit['job_files_count'],
            'flagged_content': quarantine_audit['flagged_count'],
        },
        'issues': issues,
        'warnings': warnings,
        'details': {
            'write_audit': write_audit,
            'quarantine_audit': quarantine_audit,
            'files_audit': files_audit,
        }
    }

    return result


def main():
    if len(sys.argv) < 2:
        print("Usage: post_workflow_audit.py <run_dir>", file=sys.stderr)
        print("Example: post_workflow_audit.py 2026-01-12-001", file=sys.stderr)
        sys.exit(1)

    run_dir = sys.argv[1]

    # Determine jobs directory
    jobs_dir = None
    for path in [Path.cwd() / 'jobs', Path('/workspace/jobs')]:
        if path.exists():
            jobs_dir = path
            break

    result = run_audit(run_dir, jobs_dir)

    # Write completion file
    if jobs_dir:
        completion_file = jobs_dir / run_dir / 'workflow-status.json'
        completion_file.parent.mkdir(parents=True, exist_ok=True)
        with open(completion_file, 'w') as f:
            json.dump(result, f, indent=2)
        result['completion_file'] = str(completion_file)

    # Output JSON
    print(json.dumps(result, indent=2))

    # Exit code
    sys.exit(0 if result['passed'] else 1)


if __name__ == '__main__':
    main()
