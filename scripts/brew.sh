#!/bin/bash

# Homebrew + pnpm Installation Script
# =====================================

set -e  # Exit on error

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Installing Homebrew + pnpm"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if Homebrew is installed
if command -v brew &> /dev/null; then
    echo "✅ Homebrew already installed"
    brew --version
else
    echo "📥 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo "🔧 Adding Homebrew to PATH (Apple Silicon)..."
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "✅ Homebrew installed successfully"
fi

echo ""

# Check if pnpm is installed
if command -v pnpm &> /dev/null; then
    echo "✅ pnpm already installed"
    pnpm --version
else
    echo "📥 Installing pnpm via Homebrew..."
    brew install pnpm
    echo "✅ pnpm installed successfully"
    pnpm --version
fi

echo ""
echo "✅ Homebrew + pnpm setup complete!"
