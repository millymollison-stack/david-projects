#!/bin/bash
# Codex Ralph Loop - Automated coding workflow
# Creates PRD, spawns Codex to execute, tracks progress, reports completion

CODEX_PROJECTS="/Users/davidsassistant/.openclaw/workspace/codex-projects"
WORKSPACE_PROJECTS="/Users/davidsassistant/.openclaw/workspace/projects"
PRDS_DIR="$CODEX_PROJECTS/prds"
PROMPTS_DIR="$CODEX_PROJECTS/prompts"
SESSIONS_DIR="$CODEX_PROJECTS/sessions"
COMPLETED_DIR="$CODEX_PROJECTS/completed"
LIFE_WORK="/Users/davidsassistant/.openclaw/workspace/life-work-projects"
DAILY_NOTE="$LIFE_WORK/sessions/$(date +%Y-%m-%d).md"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Codex Ralph Loop ===${NC}"

# Function to update daily notes
update_daily_notes() {
    local project_name="$1"
    local status="$2"
    local timestamp=$(date +"%H:%M")
    
    if [ -f "$DAILY_NOTE" ]; then
        echo "## Codex Projects - $timestamp" >> "$DAILY_NOTE"
        echo "- **$project_name**: $status" >> "$DAILY_NOTE"
        echo "" >> "$DAILY_NOTE"
    fi
}

# Function to run a Codex job
run_codex_job() {
    local project_name="$1"
    local prd_file="$2"
    local prompt_file="$3"
    
    echo -e "${YELLOW}Starting Codex job: $project_name${NC}"
    
    # Update daily notes - started
    update_daily_notes "$project_name" "🚀 Started"
    
    # Create session log
    local session_file="$SESSIONS_DIR/${project_name}-$(date +%Y%m%d-%H%M%S).log"
    
    # Run Codex with the prompt
    if [ -n "$prompt_file" ] && [ -f "$prompt_file" ]; then
        codex --yes "$prompt_file" 2>&1 | tee "$session_file"
    else
        # Interactive mode if no prompt
        codex --yes 2>&1 | tee "$session_file"
    fi
    
    local exit_code=${PIPESTATUS[0]}
    
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}Codex job completed successfully: $project_name${NC}"
        update_daily_notes "$project_name" "✅ Completed"
        
        # Move to completed
        mv "$prd_file" "$COMPLETED_DIR/" 2>/dev/null
        
        # Notify user
        echo -e "${GREEN}🎉 Project $project_name completed!${NC}"
    else
        echo -e "${RED}Codex job failed: $project_name (exit code: $exit_code)${NC}"
        update_daily_notes "$project_name" "❌ Failed (exit $exit_code)"
    fi
    
    return $exit_code
}

# Function to check for open projects in daily notes and workspace
check_open_projects() {
    echo -e "${YELLOW}=== Checking for Open Projects ===${NC}"
    echo ""
    
    # Check Codex projects
    echo -e "${GREEN}Codex Projects:${NC}"
    if [ -d "$SESSIONS_DIR" ]; then
        ls -1 "$SESSIONS_DIR/"*.log 2>/dev/null | while read f; do
            echo "  - $(basename "$f" .log)"
        done
        if [ -z "$(ls -A "$SESSIONS_DIR/"*.log 2>/dev/null)" ]; then
            echo "  (none running)"
        fi
    fi
    echo ""
    
    # Check workspace projects folder
    echo -e "${GREEN}Workspace Projects:${NC}"
    if [ -d "$WORKSPACE_PROJECTS" ]; then
        for project in "$WORKSPACE_PROJECTS"/*; do
            if [ -d "$project" ]; then
                PROJECT_NAME=$(basename "$project")
                # Check for signs of active work (recent files, todo files, etc.)
                TODO_FILE="$project/TODO.md"
                PROMPT_FILE="$project/PROMPT.md"
                
                if [ -f "$TODO_FILE" ]; then
                    echo "  - $PROJECT_NAME (has TODO)"
                elif [ -f "$PROMPT_FILE" ]; then
                    echo "  - $PROJECT_NAME (has PROMPT)"
                fi
            fi
        done
    fi
    echo ""
    
    # Check daily notes
    if [ -f "$DAILY_NOTE" ]; then
        echo -e "${GREEN}Today's Notes:${NC}"
        grep -E "^\- \*\*" "$DAILY_NOTE" | grep -i codex | head -5 || echo "  (no Codex entries)"
    fi
}

# Main command handling
case "$1" in
    "run")
        if [ -z "$2" ]; then
            echo "Usage: $0 run <project-name> [prompt-file]"
            exit 1
        fi
        PROJECT_NAME="$2"
        PROMPT_FILE="$3"
        
        # Use default PRD if none specified
        PRD_FILE="$PRDS_DIR/${PROJECT_NAME}.md"
        
        run_codex_job "$PROJECT_NAME" "$PRD_FILE" "$PROMPT_FILE"
        ;;
    "list")
        echo "Available PRDs:"
        ls -1 "$PRDS_DIR/"
        ;;
    "check")
        check_open_projects
        ;;
    *)
        echo "Codex Ralph Loop - Usage:"
        echo "  $0 run <project-name> [prompt-file]  - Run a Codex job"
        echo "  $0 list                              - List available PRDs"
        echo "  $0 check                             - Check open projects"
        ;;
esac
