#!/bin/bash
# Second Brain Nightly Review & QMD Indexing Script
# Runs at 2am to:
# 1. Create daily note for today
# 2. Extract relevant info from chat sessions
# 3. Update QMD index
# 4. Generate daily summary

DATE=$(date +%Y-%m-%d)
DAY=$(date +%A)
SESSION_DIR="/Users/davidsassistant/.openclaw/sessions"
LIFE_WORK_DIR="/Users/davidsassistant/.openclaw/workspace/life-work-projects"
NOTES_DIR="$LIFE_WORK_DIR/notes"
SESSIONS_DIR="$LIFE_WORK_DIR/sessions"
TEMPLATES_DIR="$LIFE_WORK_DIR/templates"
SCRIPTS_DIR="$LIFE_WORK_DIR/scripts"

echo "=== Second Brain Nightly Review - $(date) ==="

# 1. Create daily note if it doesn't exist
DAILY_NOTE="$SESSIONS_DIR/$DATE.md"
if [ ! -f "$DAILY_NOTE" ]; then
    echo "Creating daily note for $DATE..."
    bash "$SCRIPTS_DIR/daily-note.sh"
fi

# 2. Extract session info from the day
echo "Extracting session notes..."
SESSION_SUMMARY="$SESSIONS_DIR/summary-$DATE.md"

echo "# Session Summary - $DATE" > "$SESSION_SUMMARY"
echo "" >> "$SESSION_SUMMARY"
echo "## Sessions Processed" >> "$SESSION_SUMMARY"
echo "" >> "$SESSION_SUMMARY"

# Find all session files modified today
if [ -d "$SESSION_DIR" ]; then
    find "$SESSION_DIR" -type f -name "*.json" -mtime -1 2>/dev/null | while read -r session_file; do
        SESSION_NAME=$(basename "$session_file" .json)
        echo "- $SESSION_NAME" >> "$SESSION_SUMMARY"
    done
fi

echo "" >> "$SESSION_SUMMARY"
echo "## Key Information Extracted" >> "$SESSION_SUMMARY"
echo "" >> "$SESSION_SUMMARY"
echo "*To be implemented: Parse session JSON for key info*" >> "$SESSION_SUMMARY"
echo "" >> "$SESSION_SUMMARY"
echo "## Tasks Completed Today" >> "$SESSION_SUMMARY"
echo "" >> "$SESSION_SUMMARY"
echo "*Kanban task extraction to be implemented*" >> "$SESSION_SUMMARY"

# 3. Update QMD index
echo "Updating QMD index..."
qmd update

# 4. Update embeddings
echo "Updating QMD embeddings..."
qmd embed 2>/dev/null || echo "Embeddings update skipped (may take time)"

echo "=== Nightly Review Complete ==="
