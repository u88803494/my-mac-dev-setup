#!/bin/bash

# iTerm2 Configuration Sync Script
# ==================================
# Configures iTerm2 to sync preferences to project directory

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ITERM_CONFIG_DIR="$SCRIPT_DIR/config/iterm2"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚙️  Configuring iTerm2 Preferences Sync"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create config directory if it doesn't exist
echo ""
echo "Creating config directory..."
mkdir -p "$ITERM_CONFIG_DIR"

# Set iTerm2 to load preferences from custom folder
echo "Configuring iTerm2 to sync from: $ITERM_CONFIG_DIR"
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$ITERM_CONFIG_DIR"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

echo ""
echo "✅ iTerm2 configured to sync preferences!"
echo ""
echo "📝 Next steps:"
echo "   1. Restart iTerm2 to apply changes"
echo "   2. iTerm2 will now:"
echo "      • Load preferences from: $ITERM_CONFIG_DIR"
echo "      • Save changes back to this directory"
echo ""
echo "   This allows you to:"
echo "      • Sync settings across machines"
echo "      • Version control your iTerm2 config"
echo "      • Backup/restore settings easily"
echo ""
