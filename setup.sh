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
echo "║    • Development tools (git, gh, eza, zoxide)            ║"
echo "║    • GUI apps (iTerm2, VS Code, Claude Code)             ║"
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
echo "📦 Step 1/7: Installing Homebrew + pnpm"
echo "════════════════════════════════════════════════════════════"
echo ""
bash "$SCRIPT_DIR/scripts/brew.sh"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 2/7: Installing nvm + Node.js LTS"
echo "════════════════════════════════════════════════════════════"
echo ""
bash "$SCRIPT_DIR/scripts/node.sh"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 3/7: Installing Zsh + Oh My Zsh + Powerlevel10k"
echo "════════════════════════════════════════════════════════════"
echo ""
bash "$SCRIPT_DIR/scripts/zsh.sh"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 4/7: Setting up zsh-scripts symlinks"
echo "════════════════════════════════════════════════════════════"
echo ""
bash "$SCRIPT_DIR/scripts/symlink-zsh.sh"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 5/7: Installing development tools"
echo "════════════════════════════════════════════════════════════"
echo ""
bash "$SCRIPT_DIR/scripts/dev-tools.sh"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 6/7: Installing GUI applications"
echo "════════════════════════════════════════════════════════════"
echo ""
bash "$SCRIPT_DIR/scripts/apps.sh"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 7/7: Configuring iTerm2 preferences"
echo "════════════════════════════════════════════════════════════"
echo ""
bash "$SCRIPT_DIR/scripts/iterm2-config.sh"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║    ✅ Installation Complete!                              ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📝 Next steps:"
echo ""
echo "  1. Configure Git:"
echo "     • $SCRIPT_DIR/git/setup-git.sh"
echo ""
echo "  2. Restart your terminal to apply all changes"
echo ""
echo "  3. Optional: Install SuperClaude Framework + MCP Servers (recommended):"
echo "     pipx install SuperClaude && SuperClaude install"
echo ""
echo "  4. Verify installation:"
echo "     • Homebrew:  brew --version"
echo "     • pnpm:      pnpm --version"
echo "     • Node.js:   node --version"
echo "     • git:       git --version"
echo "     • eza:       eza --version"
echo "     • zoxide:    zoxide --version"
echo ""
echo "  5. Your shell enhancements are ready:"
echo "     • t()     → eza tree (copied to clipboard)"
echo "     • j       → zoxide smart jump"
echo "     • c       → claude"
echo "     • cls     → clear"
echo ""
echo "🎉 Happy coding!"
echo ""
