#!/bin/bash
# Second Brain Daily Note Generator
# Creates a daily note based on PARA method

DATE=$(date +%Y-%m-%d)
DAY=$(date +%A)
YEAR=$(date +%Y)
MONTH=$(date +%B)

LIFE_WORK_DIR="/Users/davidsassistant/.openclaw/workspace/life-work-projects"
NOTES_DIR="$LIFE_WORK_DIR/notes"
SESSIONS_DIR="$LIFE_WORK_DIR/sessions"
TEMPLATES_DIR="$LIFE_WORK_DIR/templates"

# Create directories if they don't exist
mkdir -p "$NOTES_DIR" "$SESSIONS_DIR" "$TEMPLATES_DIR"

DAILY_NOTE="$SESSIONS_DIR/$DATE.md"

# Check if already exists
if [ -f "$DAILY_NOTE" ]; then
    echo "Daily note for $DATE already exists"
    exit 0
fi

# Get yesterday for reference
YESTERDAY=$(date -v-1d +%Y-%m-%d)
YESTERDAY_NOTE="$SESSIONS_DIR/$YESTERDAY.md"

echo "# Daily Note - $DATE" > "$DAILY_NOTE"
echo "" >> "$DAILY_NOTE"
echo "## Date" >> "$DAILY_NOTE"
echo "- $DATE ($DAY)" >> "$DAILY_NOTE"
echo "" >> "$DAILY_NOTE"
echo "## Top Priorities (from Kanban)" >> "$DAILY_NOTE"
echo "- [ ] " >> "$DAILY_NOTE"
echo "" >> "$DAILY_NOTE"
echo "## Today" >> "$DAILY_NOTE"
echo "" >> "$DAILY_NOTE"
echo "### Morning" >> "$DAILY_NOTE"
echo "- " >> "$DAILY_NOTE"
echo "" >> "$DAILY_NOTE"
echo "### Afternoon" >> "$DAILY_NOTE"
echo "- " >> "$DAILY_NOTE"
echo "" >> "$DAILY_NOTE"
echo "### Evening" >> "$DAILY_NOTE"
echo "- " >> "$DAILY_NOTE"
echo "" >> "$DAILY_NOTE"
echo "## Notes & Insights" >> "$DAILY_NOTE"
echo "" >> "$DAILY_NOTE"
echo "## Ideas" >> "$DAILY_NOTE"
echo "" >> "$DAILY_NOTE"
echo "## Tomorrow" >> "$DAILY_NOTE"
echo "- " >> "$DAILY_NOTE"
echo "" >> "$DAILY_NOTE"
echo "---" >> "$DAILY_NOTE"
echo "*Second Brain System - $DAY*" >> "$DAILY_NOTE"

echo "Created daily note: $DAILY_NOTE"
