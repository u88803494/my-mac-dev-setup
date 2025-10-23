#!/bin/bash

# Cleanup Script for mac-dev-setup
# ==================================
# Use this to uninstall everything installed by setup.sh
# Useful for testing the installation process

set -e

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║    🧹 Cleanup Script                                      ║"
echo "║                                                            ║"
echo "║    This will remove:                                      ║"
echo "║    • Homebrew packages installed by this setup           ║"
echo "║    • Oh My Zsh and plugins                               ║"
echo "║    • nvm and Node.js                                     ║"
echo "║    • Configuration changes (with backup)                 ║"
echo "║                                                            ║"
echo "║    ⚠️  WARNING: This is for testing purposes only!       ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

read -p "Are you sure you want to continue? (yes/NO): " -r
echo
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""

# ==============================================================================
# 1. Remove Homebrew packages
# ==============================================================================
echo "════════════════════════════════════════════════════════════"
echo "🗑️  Step 1/5: Removing Homebrew packages"
echo "════════════════════════════════════════════════════════════"
echo ""

# Dev tools
echo "Removing dev tools..."
brew uninstall --ignore-dependencies git gh git-delta eza zoxide 2>/dev/null || echo "  (some packages not installed)"

# Zsh plugins
echo "Removing Zsh plugins..."
brew uninstall zsh-autosuggestions zsh-syntax-highlighting 2>/dev/null || echo "  (plugins not installed)"

# pnpm
echo "Removing pnpm..."
brew uninstall pnpm 2>/dev/null || echo "  (pnpm not installed)"

# macOS apps
echo "Removing GUI applications..."
brew uninstall --cask iterm2 visual-studio-code claude-code 2>/dev/null || echo "  (some apps not installed)"

# Note: We don't uninstall Homebrew itself as it might be used by other things

echo "✅ Homebrew packages removed"

# ==============================================================================
# 2. Remove Oh My Zsh
# ==============================================================================
echo ""
echo "════════════════════════════════════════════════════════════"
echo "🗑️  Step 2/5: Removing Oh My Zsh"
echo "════════════════════════════════════════════════════════════"
echo ""

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Removing Oh My Zsh..."
    rm -rf "$HOME/.oh-my-zsh"
    echo "✅ Oh My Zsh removed"
else
    echo "✅ Oh My Zsh not installed"
fi

# ==============================================================================
# 3. Remove nvm and Node.js
# ==============================================================================
echo ""
echo "════════════════════════════════════════════════════════════"
echo "🗑️  Step 3/5: Removing nvm and Node.js"
echo "════════════════════════════════════════════════════════════"
echo ""

if [ -d "$HOME/.nvm" ]; then
    echo "Removing nvm..."
    rm -rf "$HOME/.nvm"
    echo "✅ nvm removed"
else
    echo "✅ nvm not installed"
fi

# ==============================================================================
# 4. Restore configuration files
# ==============================================================================
echo ""
echo "════════════════════════════════════════════════════════════"
echo "🗑️  Step 4/5: Restoring configuration files"
echo "════════════════════════════════════════════════════════════"
echo ""

# Backup current .zshrc before restoring
if [ -f "$HOME/.zshrc" ]; then
    BACKUP_NAME="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backing up current .zshrc to: $BACKUP_NAME"
    cp "$HOME/.zshrc" "$BACKUP_NAME"
fi

# Restore .zshrc from the oldest backup (original)
if [ -f "$HOME/.zshrc.pre-oh-my-zsh" ]; then
    echo "Restoring original .zshrc from .zshrc.pre-oh-my-zsh"
    cp "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc"
    echo "✅ .zshrc restored"
elif [ -f "$HOME/.zshrc.bak" ]; then
    echo "Restoring .zshrc from .zshrc.bak"
    cp "$HOME/.zshrc.bak" "$HOME/.zshrc"
    echo "✅ .zshrc restored"
else
    echo "⚠️  No .zshrc backup found, creating minimal .zshrc"
    cat > "$HOME/.zshrc" << 'EOF'
# Minimal .zshrc
# Created by cleanup script

# Basic prompt
PS1="%n@%m %1~ %# "

# Homebrew
if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
EOF
    echo "✅ Minimal .zshrc created"
fi

# Remove p10k configuration
if [ -f "$HOME/.p10k.zsh" ]; then
    echo "Removing Powerlevel10k configuration..."
    rm "$HOME/.p10k.zsh"
    echo "✅ .p10k.zsh removed"
fi

# Remove iTerm2 custom preferences setting
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Resetting iTerm2 preferences to default location..."
    defaults delete com.googlecode.iterm2 PrefsCustomFolder 2>/dev/null || true
    defaults delete com.googlecode.iterm2 LoadPrefsFromCustomFolder 2>/dev/null || true
    echo "✅ iTerm2 preferences reset"
fi

# ==============================================================================
# 5. Clean up temporary files
# ==============================================================================
echo ""
echo "════════════════════════════════════════════════════════════"
echo "🗑️  Step 5/5: Cleaning up temporary files"
echo "════════════════════════════════════════════════════════════"
echo ""

# Remove .zshrc backup files created by our scripts
echo "Removing .zshrc backup files..."
rm -f "$HOME/.zshrc.bak" 2>/dev/null || true

# Note: We keep .zshrc.pre-oh-my-zsh as it's the original backup

echo "✅ Temporary files cleaned"

# ==============================================================================
# Summary
# ==============================================================================
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║    ✅ Cleanup Complete!                                   ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📝 What was done:"
echo ""
echo "  ✅ Removed Homebrew packages (dev tools, GUI apps)"
echo "  ✅ Removed Oh My Zsh and plugins"
echo "  ✅ Removed nvm and Node.js"
echo "  ✅ Restored .zshrc configuration"
echo "  ✅ Cleaned up temporary files"
echo ""
echo "📝 What was preserved:"
echo ""
echo "  ✓ Homebrew itself (might be used by other apps)"
echo "  ✓ Your .zshrc backup at: $BACKUP_NAME"
echo "  ✓ Git repositories and personal files"
echo ""
echo "📝 Next steps:"
echo ""
echo "  1. Restart your terminal to apply changes"
echo "  2. Run ./setup.sh to reinstall if needed"
echo ""
echo "🎉 Ready for a fresh installation!"
echo ""
