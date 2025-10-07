#!/bin/bash

# Mac Development Environment Setup Script
# ==========================================
# One-command setup for new macOS machines

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║    🚀 Mac Development Environment Setup                   ║"
echo "║                                                            ║"
echo "║    This script will install and configure:                ║"
echo "║    • Homebrew + pnpm                                      ║"
echo "║    • nvm + Node.js LTS                                    ║"
echo "║    • Zsh + Oh My Zsh + Powerlevel10k + Plugins           ║"
echo "║    • Custom zsh aliases (zsh-scripts repo)               ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

read -p "Continue with installation? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 1/4: Installing Homebrew + pnpm"
echo "════════════════════════════════════════════════════════════"
echo ""
bash "$SCRIPT_DIR/scripts/brew.sh"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 2/4: Installing nvm + Node.js LTS"
echo "════════════════════════════════════════════════════════════"
echo ""
bash "$SCRIPT_DIR/scripts/node.sh"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 3/4: Installing Zsh + Oh My Zsh + Powerlevel10k"
echo "════════════════════════════════════════════════════════════"
echo ""
bash "$SCRIPT_DIR/scripts/zsh.sh"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 4/4: Setting up zsh-scripts symlinks"
echo "════════════════════════════════════════════════════════════"
echo ""
bash "$SCRIPT_DIR/scripts/symlink-zsh.sh"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║    ✅ Installation Complete!                              ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📝 Next steps:"
echo ""
echo "  1. Configure Git (choose one):"
echo "     • Personal:  $SCRIPT_DIR/git/setup-git.sh"
echo ""
echo "  2. Restart your terminal to apply all changes"
echo ""
echo "  3. Verify installation:"
echo "     • Homebrew:  brew --version"
echo "     • pnpm:      pnpm --version"
echo "     • Node.js:   node --version"
echo "     • nvm:       nvm --version"
echo ""
echo "  4. Your custom aliases are ready:"
echo "     • c       → claude"
echo "     • g       → gemini"
echo "     • cls     → clear"
echo "     • uuid    → generate UUID and copy to clipboard"
echo ""
echo "🎉 Happy coding!"
echo ""
