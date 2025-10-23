#!/bin/bash

# GUI Applications Installation Script
# ======================================
# Installs macOS GUI applications

set -e  # Exit on error

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Installing GUI Applications"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo ""
echo "Installing applications..."

# iTerm2
brew install --cask iterm2 2>/dev/null || echo "✅ iTerm2 already installed"

# Visual Studio Code
brew install --cask visual-studio-code 2>/dev/null || echo "✅ VS Code already installed"

# Claude Code CLI
brew install --cask claude-code 2>/dev/null || echo "✅ Claude Code already installed"

echo ""
echo "✅ GUI applications installation complete!"
echo ""
echo "Installed applications:"
echo "  • iTerm2 - Terminal emulator"
echo "  • Visual Studio Code - Code editor"
echo "  • Claude Code - Claude AI CLI"
echo ""
