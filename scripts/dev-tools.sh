#!/bin/bash

# Development Tools Installation Script
# =======================================
# Installs essential development tools

set -e  # Exit on error

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Installing Development Tools"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Git toolchain
echo ""
echo "Installing Git toolchain..."
brew install git gh git-delta 2>/dev/null || echo "✅ Git tools already installed"

# Modern CLI tools
echo ""
echo "Installing modern CLI tools..."
brew install eza zoxide 2>/dev/null || echo "✅ CLI tools already installed"

# Python tools (commented out - uncomment when needed)
# echo ""
# echo "Installing Python tools..."
# brew install pipx uv 2>/dev/null || echo "✅ Python tools already installed"

echo ""
echo "✅ Development tools installation complete!"
echo ""
echo "Installed tools:"
echo "  • git, gh, git-delta - Git toolchain"
echo "  • eza - Modern ls replacement (used by t() function)"
echo "  • zoxide - Smart cd (used by j alias)"
echo ""
echo "📝 Python tools (pipx, uv) are commented out to save space."
echo "   Uncomment in scripts/dev-tools.sh when needed."
echo ""
