#!/bin/bash
# QMD Nightly Cleanup & Indexing Script
# Runs at 2am to extract relevant info from chat sessions and update QMD index

DATE=$(date +%Y-%m-%d)
SESSION_DIR="/Users/davidsassistant/.openclaw/sessions"
LIFE_WORK_DIR="/Users/davidsassistant/.openclaw/workspace/life-work-projects"
OUTPUT_FILE="$LIFE_WORK_DIR/sessions/$DATE.md"

echo "=== QMD Nightly Cleanup $(date) ==="

# Create sessions directory if it doesn't exist
mkdir -p "$LIFE_WORK_DIR/sessions"

# Start the output file
echo "# Session Notes - $DATE" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Check if sessions directory exists and has content
if [ -d "$SESSION_DIR" ]; then
    echo "Processing sessions from $SESSION_DIR..."
    
    # Get all session transcript files (limit to last 24 hours)
    find "$SESSION_DIR" -type f -name "*.json" -mtime -1 2>/dev/null | while read -r session_file; do
        echo "Processing: $session_file"
        # Extract relevant content - this is a simplified version
        # In production, you'd parse the JSON and extract meaningful info
        basename "$session_file" >> "$OUTPUT_FILE"
    done
else
    echo "Sessions directory not found: $SESSION_DIR"
fi

echo "" >> "$OUTPUT_FILE"
echo "--- End of $DATE ---" >> "$OUTPUT_FILE"

# Update QMD index
echo "Updating QMD index..."
qmd update

echo "=== Cleanup Complete ==="
