# WFID Skills Inventory (snapshot 2026-03-14)

Skills found in `.claude/skills/`:

## bootstrap
Bootstrap the WFID pensieve on a fresh machine. Rebuilds audit.db from SQL increments, creates the session-memory venv, installs dependencies, and runs sync to generate memory.db, embeddings, turn pairs, and the professor snapshot. Run after cloning the repo or when derived data is missing.

## inbox-triage
Triage new files from inbox/ into the pensieve. Use when inbox/ contains files to process. Handles categorization, Obsidian formatting, topics extraction, chunking evaluation, file moves, and MOC updates.

## mfa-professor
University-level MFA creative writing professor specializing in magical realism. Use ONLY for work on "Waking From Innocent Dreams." Triggers on phrases like "I'd like to work with Professor Claude on...", "Professor Claude, I need help with...", or "Can I get feedback from my MFA professor?" Provides craft feedback through immersive roleplay with stage directions. Does NOT rewrite student text.

## note-that
Save the last Professor Claude response as an individual feedback note. Use when the user invokes /note-that after receiving feedback worth preserving.
