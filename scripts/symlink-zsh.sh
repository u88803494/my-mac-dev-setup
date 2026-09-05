#!/bin/bash

# Symlink zsh-scripts Repository
# =================================

set -e  # Exit on error

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔗 Setting up zsh-scripts symlinks"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

ZSH_SCRIPTS_REPO="${PERSONAL_DIR:-$HOME/Developer/Personal}/zsh-scripts"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Check if zsh-scripts repo exists
if [ ! -d "$ZSH_SCRIPTS_REPO" ]; then
    echo "❌ Error: zsh-scripts repository not found at $ZSH_SCRIPTS_REPO"
    echo ""
    echo "📥 Please clone the repository first:"
    echo "   git clone git@github.com:u88803494/zsh-scripts.git \"$ZSH_SCRIPTS_REPO\""
    echo ""
    exit 1
fi

echo "✅ Found zsh-scripts repository"

# Create symlink for the entire repo
if [ -L "$ZSH_CUSTOM/zsh-scripts" ]; then
    echo "✅ Symlink $ZSH_CUSTOM/zsh-scripts already exists"
elif [ -e "$ZSH_CUSTOM/zsh-scripts" ]; then
    echo "⚠️  $ZSH_CUSTOM/zsh-scripts exists but is not a symlink"
    echo "   Please remove it manually and run this script again"
    exit 1
else
    echo "🔗 Creating symlink: $ZSH_CUSTOM/zsh-scripts → $ZSH_SCRIPTS_REPO"
    ln -sf "$ZSH_SCRIPTS_REPO" "$ZSH_CUSTOM/zsh-scripts"
    echo "✅ Symlink created"
fi

echo ""

# Create symlink for custom.plugin.zsh directly in custom folder (so it gets loaded)
if [ -L "$ZSH_CUSTOM/custom.plugin.zsh" ]; then
    echo "✅ Symlink $ZSH_CUSTOM/custom.plugin.zsh already exists"
elif [ -e "$ZSH_CUSTOM/custom.plugin.zsh" ]; then
    echo "⚠️  $ZSH_CUSTOM/custom.plugin.zsh exists but is not a symlink"
    echo "   Please remove it manually and run this script again"
    exit 1
else
    echo "🔗 Creating symlink: $ZSH_CUSTOM/custom.plugin.zsh → $ZSH_SCRIPTS_REPO/custom.plugin.zsh"
    ln -sf "$ZSH_SCRIPTS_REPO/custom.plugin.zsh" "$ZSH_CUSTOM/custom.plugin.zsh"
    echo "✅ Symlink created"
fi

echo ""
echo "✅ zsh-scripts setup complete!"
echo ""
echo "📝 Your custom aliases are now available:"
echo "   c       → claude"
echo "   g       → gemini"
echo "   cls     → clear"
echo "   uuid    → generate UUID and copy to clipboard"
echo ""
echo "💡 Restart your terminal or run: source ~/.zshrc"
