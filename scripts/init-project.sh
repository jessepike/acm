#!/bin/bash

# ACM Project Initialization Script
# Creates project scaffolding for Discover stage

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get ACM directory (parent of scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACM_DIR="$(dirname "$SCRIPT_DIR")"

echo ""
echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}  ACM Project Initialization${NC}"
echo -e "${BLUE}==========================================${NC}"
echo ""

# ============================================
# STEP 1: Check/Update Global CLAUDE.md
# ============================================

echo -e "${YELLOW}Step 1: Global CLAUDE.md Check${NC}"
echo "----------------------------------------"

GLOBAL_DIR="$HOME/.claude"
GLOBAL_FILE="$GLOBAL_DIR/CLAUDE.md"
GLOBAL_TEMPLATE="$ACM_DIR/CLAUDE.md"

if [ ! -f "$GLOBAL_TEMPLATE" ]; then
    echo -e "${RED}Error: Global template not found at $GLOBAL_TEMPLATE${NC}"
    exit 1
fi

if [ -f "$GLOBAL_FILE" ]; then
    echo -e "Global CLAUDE.md exists at: ${YELLOW}$GLOBAL_FILE${NC}"
    echo ""
    read -p "Update from ACM? (y/N): " OVERWRITE_GLOBAL

    if [[ "$OVERWRITE_GLOBAL" =~ ^[Yy]$ ]]; then
        BACKUP_FILE="$GLOBAL_FILE.backup.$(date +%Y%m%d%H%M%S)"
        cp "$GLOBAL_FILE" "$BACKUP_FILE"
        echo -e "${GREEN}Backed up to: $BACKUP_FILE${NC}"
        cp "$GLOBAL_TEMPLATE" "$GLOBAL_FILE"
        echo -e "${GREEN}Updated global CLAUDE.md${NC}"
    else
        echo "Keeping existing global CLAUDE.md."
    fi
else
    echo "No global CLAUDE.md found."
    mkdir -p "$GLOBAL_DIR"
    cp "$GLOBAL_TEMPLATE" "$GLOBAL_FILE"
    echo -e "${GREEN}Created: $GLOBAL_FILE${NC}"
fi

echo ""

# ============================================
# STEP 2: Select Project Type
# ============================================

echo -e "${YELLOW}Step 2: Project Type${NC}"
echo "----------------------------------------"
echo ""
echo "Available types:"
echo "  1) app       - Deployed software (websites, APIs, mobile apps)"
echo "  2) artifact  - Single deliverable (reports, presentations)"
echo "  3) workflow  - Automation/orchestration (pipelines, integrations)"
echo ""

read -p "Select type [1-3]: " TYPE_CHOICE

case $TYPE_CHOICE in
    1) PROJECT_TYPE="app" ;;
    2) PROJECT_TYPE="artifact" ;;
    3) PROJECT_TYPE="workflow" ;;
    *)
        echo -e "${RED}Invalid selection. Exiting.${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "Selected: ${GREEN}$PROJECT_TYPE${NC}"
echo ""

# ============================================
# STEP 3: Select Scale Modifier
# ============================================

echo -e "${YELLOW}Step 3: Scale${NC}"
echo "----------------------------------------"
echo ""
echo "  1) personal   - Just you, private"
echo "  2) shared     - Family, friends, small group"
echo "  3) community  - Public, not monetized"
echo "  4) commercial - Revenue intent, business requirements"
echo ""

read -p "Select scale [1-4]: " SCALE_CHOICE

case $SCALE_CHOICE in
    1) SCALE="personal" ;;
    2) SCALE="shared" ;;
    3) SCALE="community" ;;
    4) SCALE="commercial" ;;
    *)
        echo -e "${RED}Invalid selection. Exiting.${NC}"
        exit 1
        ;;
esac

echo ""

# ============================================
# STEP 4: Get Target Path
# ============================================

echo -e "${YELLOW}Step 4: Target Path${NC}"
echo "----------------------------------------"
echo ""
read -p "Enter project path: " TARGET_PATH

# Expand ~
TARGET_PATH="${TARGET_PATH/#\~/$HOME}"

if [ -d "$TARGET_PATH" ]; then
    echo -e "${YELLOW}Warning: Directory already exists.${NC}"
    read -p "Continue and add ACM scaffolding? (y/N): " CONTINUE
    if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo ""

# ============================================
# STEP 5: Get Project Name
# ============================================

echo -e "${YELLOW}Step 5: Project Name${NC}"
echo "----------------------------------------"
echo ""
read -p "Enter project name: " PROJECT_NAME

echo ""

# ============================================
# STEP 6: Create Scaffolding
# ============================================

echo -e "${YELLOW}Step 6: Creating Scaffolding${NC}"
echo "----------------------------------------"
echo ""

# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Base structure (all types)
echo "Creating base structure..."
mkdir -p "$TARGET_PATH/.claude/rules"
mkdir -p "$TARGET_PATH/docs"
mkdir -p "$TARGET_PATH/_archive"

# Copy stubs and populate project name/date
echo "Creating docs/intent.md..."
sed -e "s/\[Project Name\]/$PROJECT_NAME/g" \
    -e "s/YYYY-MM-DD/$CURRENT_DATE/g" \
    "$ACM_DIR/stubs/intent.md" > "$TARGET_PATH/docs/intent.md"

echo "Creating docs/discover-brief.md..."
sed -e "s/\[Project Name\]/$PROJECT_NAME/g" \
    -e "s/YYYY-MM-DD/$CURRENT_DATE/g" \
    -e "s/\[personal | shared | community | commercial\]/$SCALE/g" \
    "$ACM_DIR/stubs/brief.md" > "$TARGET_PATH/docs/discover-brief.md"

echo "Creating docs/status.md..."
sed -e "s/\[Project Name\]/$PROJECT_NAME/g" \
    -e "s/YYYY-MM-DD/$CURRENT_DATE/g" \
    "$ACM_DIR/stubs/status.md" > "$TARGET_PATH/docs/status.md"

# Type-specific structure and CLAUDE.md
case $PROJECT_TYPE in
    app)
        mkdir -p "$TARGET_PATH/src"
        mkdir -p "$TARGET_PATH/tests"
        mkdir -p "$TARGET_PATH/config"
        sed -e "s/\[Project Name\]/$PROJECT_NAME/g" \
            -e "s/\[personal | shared | community | commercial\]/$SCALE/g" \
            "$ACM_DIR/stubs/claude-md/app.md" > "$TARGET_PATH/.claude/CLAUDE.md"
        echo "  Created: src/, tests/, config/"
        ;;
    artifact)
        mkdir -p "$TARGET_PATH/assets"
        mkdir -p "$TARGET_PATH/output"
        mkdir -p "$TARGET_PATH/docs/research"
        sed -e "s/\[Project Name\]/$PROJECT_NAME/g" \
            -e "s/\[personal | shared | community | commercial\]/$SCALE/g" \
            "$ACM_DIR/stubs/claude-md/artifact.md" > "$TARGET_PATH/.claude/CLAUDE.md"
        echo "  Created: assets/, output/, docs/research/"
        ;;
    workflow)
        mkdir -p "$TARGET_PATH/workflows"
        mkdir -p "$TARGET_PATH/scripts"
        sed -e "s/\[Project Name\]/$PROJECT_NAME/g" \
            -e "s/\[personal | shared | community | commercial\]/$SCALE/g" \
            "$ACM_DIR/stubs/claude-md/workflow.md" > "$TARGET_PATH/.claude/CLAUDE.md"
        echo "  Created: workflows/, scripts/"
        ;;
esac

# Create project README
cat > "$TARGET_PATH/README.md" << EOF
# $PROJECT_NAME

## Intent

See [docs/intent.md](docs/intent.md)

## Status

See [docs/status.md](docs/status.md) for current state.

## Classification

- **Type:** $PROJECT_TYPE
- **Scale:** $SCALE

## Quick Start

[To be populated during Design stage]

---

*Managed with [ACM](https://github.com/your-org/acm)*
EOF

echo "  Created: .claude/, docs/, _archive/, README.md"
echo ""

# ============================================
# DONE
# ============================================

echo -e "${GREEN}==========================================${NC}"
echo -e "${GREEN}  Project Initialized!${NC}"
echo -e "${GREEN}==========================================${NC}"
echo ""
echo "Location: $TARGET_PATH"
echo "Type: $PROJECT_TYPE"
echo "Scale: $SCALE"
echo ""
echo "Files created:"
echo "  .claude/CLAUDE.md     - Project context (agents read this first)"
echo "  docs/intent.md        - North Star (define your why)"
echo "  docs/discover-brief.md - Project contract (define what)"
echo "  docs/status.md        - Session state (tracks progress)"
echo "  README.md             - Project overview"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. cd $TARGET_PATH"
echo "  2. Edit docs/intent.md — Define your North Star"
echo "  3. Start Discover stage — flesh out the brief"
echo ""
