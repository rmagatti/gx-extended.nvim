#!/bin/bash

# Test Runner for gx-extended.nvim
# This script helps verify your gx-extended setup

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Emojis
CHECK="✅"
CROSS="❌"
INFO="ℹ️"
ROCKET="🚀"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  ${ROCKET} gx-extended.nvim Test Runner"
echo "════════════════════════════════════════════════════════════"
echo ""

# Check if we're in the test-samples directory
if [ ! -f "package.json" ] || [ ! -f "README.md" ]; then
    echo -e "${CROSS} ${RED}Error: Not in test-samples directory${NC}"
    echo "Please run from: ~/Projects/gx-extended.nvim/test-samples/"
    exit 1
fi

echo -e "${CHECK} ${GREEN}Found test files${NC}"
echo ""

# Check if Neovim is installed
if ! command -v nvim &> /dev/null; then
    echo -e "${CROSS} ${RED}Neovim is not installed${NC}"
    exit 1
fi

echo -e "${CHECK} ${GREEN}Neovim is installed${NC}"
NVIM_VERSION=$(nvim --version | head -n1)
echo "   Version: $NVIM_VERSION"
echo ""

# Check if git is installed and if we're in a git repo
if command -v git &> /dev/null; then
    if git rev-parse --is-inside-work-tree &> /dev/null; then
        echo -e "${CHECK} ${GREEN}Git repository detected${NC}"
        REMOTE_URL=$(git config --get remote.origin.url 2>/dev/null || echo "No remote")
        echo "   Remote: $REMOTE_URL"
        BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
        echo "   Branch: $BRANCH"
        echo ""
        echo -e "${INFO} ${BLUE}Git commit and file permalink features will work${NC}"
    else
        echo -e "${YELLOW}Not in a git repository${NC}"
        echo -e "${INFO} ${BLUE}Git-related features won't work${NC}"
    fi
else
    echo -e "${YELLOW}Git is not installed${NC}"
fi
echo ""

# List test files
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📁 Available Test Files:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

files=(
    "package.json:NPM packages"
    "test.ts:NPM imports, git commits, CVE, PEP"
    "Cargo.toml:Rust crates"
    "go.mod:Go packages"
    "Dockerfile:Docker images"
    "README.md:Markdown links, CVE, PEP, commits, URLs"
    "Brewfile:Homebrew formulas and casks"
)

for file in "${files[@]}"; do
    IFS=':' read -r filename description <<< "$file"
    if [ -f "$filename" ]; then
        echo -e "${CHECK} ${GREEN}$filename${NC}"
        echo "   Tests: $description"
    else
        echo -e "${CROSS} ${RED}$filename${NC} (missing)"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 Quick Tests:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Test 1: Check if gx-extended is in Neovim config
CONFIG_FILE="$HOME/.config/nvim/lua/rmagatti/gx-extended.lua"
if [ -f "$CONFIG_FILE" ]; then
    echo -e "${CHECK} ${GREEN}gx-extended config found${NC}"

    # Check if optional features are enabled
    if grep -q "enable_npm_imports = true" "$CONFIG_FILE"; then
        echo -e "   ${CHECK} NPM imports enabled"
    else
        echo -e "   ${YELLOW}⚠ NPM imports disabled${NC}"
    fi

    if grep -q "enable_github_file_line = true" "$CONFIG_FILE"; then
        echo -e "   ${CHECK} GitHub file permalinks enabled"
    else
        echo -e "   ${YELLOW}⚠ GitHub file permalinks disabled${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Config file not found at expected location${NC}"
    echo "   Expected: $CONFIG_FILE"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Manual Testing Instructions:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Quick smoke test (2 minutes):"
echo "   ${BLUE}nvim package.json${NC}"
echo "   - Move cursor to '\"express\"'"
echo "   - Press 'gx'"
echo "   - Should open: https://www.npmjs.com/package/express"
echo ""
echo "2. Test NPM imports (if enabled):"
echo "   ${BLUE}nvim test.ts${NC}"
echo "   - Move cursor to 'import axios'"
echo "   - Press 'gx'"
echo "   - Should open: https://www.npmjs.com/package/axios"
echo ""
echo "3. Test GitHub permalinks (if enabled):"
echo "   ${BLUE}nvim README.md${NC}"
echo "   - Move cursor to any line"
echo "   - Press 'gx'"
echo "   - Should open GitHub permalink to that line"
echo ""
echo "4. Test CVE references:"
echo "   ${BLUE}nvim README.md${NC}"
echo "   - Move cursor to 'CVE-2024-1234'"
echo "   - Press 'gx'"
echo "   - Should open CVE database"
echo ""
echo "5. Full test suite:"
echo "   ${BLUE}nvim .${NC}"
echo "   Open each test file and try patterns listed in TESTING.md"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📚 Documentation:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "For detailed testing instructions, see:"
echo "  ${BLUE}../TESTING.md${NC}"
echo ""
echo "For all features and examples:"
echo "  ${BLUE}../README.md${NC}"
echo "  ${BLUE}../ADVANCED.md${NC}"
echo "  ${BLUE}../EXAMPLES.md${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Interactive menu
echo "What would you like to do?"
echo ""
echo "  1) Open package.json (test npm packages)"
echo "  2) Open test.ts (test npm imports)"
echo "  3) Open README.md (test all reference types)"
echo "  4) Open Cargo.toml (test Rust crates)"
echo "  5) Open all test files in Neovim"
echo "  6) Enable debug logging in config"
echo "  7) View test documentation"
echo "  8) Exit"
echo ""
read -p "Enter choice [1-8]: " choice

case $choice in
    1)
        echo ""
        echo -e "${ROCKET} Opening package.json..."
        echo "Test: Move cursor to any package name and press 'gx'"
        sleep 1
        nvim package.json
        ;;
    2)
        echo ""
        echo -e "${ROCKET} Opening test.ts..."
        echo "Test: Move cursor to any import line and press 'gx'"
        sleep 1
        nvim test.ts
        ;;
    3)
        echo ""
        echo -e "${ROCKET} Opening README.md..."
        echo "Test: Try CVE references, PEP references, markdown links, URLs"
        sleep 1
        nvim README.md
        ;;
    4)
        echo ""
        echo -e "${ROCKET} Opening Cargo.toml..."
        echo "Test: Move cursor to any crate name and press 'gx'"
        sleep 1
        nvim Cargo.toml
        ;;
    5)
        echo ""
        echo -e "${ROCKET} Opening all test files..."
        sleep 1
        nvim .
        ;;
    6)
        echo ""
        echo "To enable debug logging, add this to your config:"
        echo ""
        echo -e "${BLUE}require('gx-extended').setup {${NC}"
        echo -e "${BLUE}  log_level = vim.log.levels.DEBUG,${NC}"
        echo -e "${BLUE}}${NC}"
        echo ""
        echo "Then check logs with: :messages"
        ;;
    7)
        echo ""
        if [ -f "../TESTING.md" ]; then
            less ../TESTING.md
        else
            echo -e "${CROSS} TESTING.md not found"
        fi
        ;;
    8)
        echo ""
        echo "Happy testing! 🎉"
        exit 0
        ;;
    *)
        echo ""
        echo -e "${YELLOW}Invalid choice${NC}"
        exit 1
        ;;
esac
