#!/bin/bash

# nvm + Node.js LTS Installation Script
# =======================================

set -e  # Exit on error

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Installing nvm + Node.js LTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if nvm is installed
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    echo "✅ nvm already installed"
    source "$HOME/.nvm/nvm.sh"
    nvm --version
else
    echo "📥 Installing nvm..."

    # Install nvm via Homebrew
    brew install nvm

    # Create nvm directory
    mkdir -p ~/.nvm

    # Add nvm to shell configuration
    if ! grep -q "NVM_DIR" ~/.zshrc 2>/dev/null; then
        echo "" >> ~/.zshrc
        echo "# nvm" >> ~/.zshrc
        echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
        echo '[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"' >> ~/.zshrc
        echo '[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"' >> ~/.zshrc
    fi

    # Load nvm for current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"

    echo "✅ nvm installed successfully"
fi

echo ""

# Install latest LTS Node.js
echo "📥 Installing Node.js LTS..."
nvm install --lts

echo ""

# Set LTS as default
echo "🔧 Setting LTS as default..."
nvm alias default lts/*

echo ""

# Verify installation
echo "✅ Node.js setup complete!"
echo "Node version: $(node --version)"
echo "npm version: $(npm --version)"
