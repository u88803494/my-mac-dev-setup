#!/bin/bash

# Mac Development Environment Bootstrap
# =======================================
# Minimal setup to enable Claude Code AI-powered configuration
# This script installs: Homebrew → mise → Node.js → Claude Code → git

set -e  # Exit on error

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║    🚀 Mac Dev Environment Bootstrap                       ║"
echo "║    Installing: Homebrew → mise → Node.js → Claude Code   ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# ============================================================================
# Step 1: Install Homebrew
# ============================================================================
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 1/5: Installing Homebrew"
echo "════════════════════════════════════════════════════════════"
echo ""

if command -v brew &> /dev/null; then
    echo "✅ Homebrew already installed"
    brew --version
else
    echo "📥 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == 'arm64' ]]; then
        echo "🔧 Adding Homebrew to PATH for Apple Silicon..."
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "✅ Homebrew installed successfully"
fi

echo ""

# ============================================================================
# Step 2: Install mise
# ============================================================================
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 2/5: Installing mise (version manager)"
echo "════════════════════════════════════════════════════════════"
echo ""

if command -v mise &> /dev/null; then
    echo "✅ mise already installed"
    mise --version
else
    echo "📥 Installing mise..."
    brew install mise
    echo "✅ mise installed successfully"
fi

echo ""

# ============================================================================
# Step 3: Install Node.js and pnpm via mise
# ============================================================================
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 3/5: Installing Node.js LTS and pnpm via mise"
echo "════════════════════════════════════════════════════════════"
echo ""

# Activate mise for current session
eval "$(mise activate bash)"

echo "📥 Installing Node.js LTS..."
mise use -g node@lts

echo "📥 Installing pnpm..."
mise use -g pnpm@latest

echo "✅ Node.js $(node --version) installed via mise"
echo "✅ pnpm $(pnpm --version) installed via mise"

echo ""

# ============================================================================
# Step 4: Install Claude Code
# ============================================================================
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 4/5: Installing Claude Code"
echo "════════════════════════════════════════════════════════════"
echo ""

if command -v claude &> /dev/null; then
    echo "✅ Claude Code already installed"
    claude --version
else
    echo "📥 Installing Claude Code via npm..."
    npm install -g @anthropic-ai/claude-code
    echo "✅ Claude Code installed successfully"
fi

echo ""

# ============================================================================
# Step 5: Install git
# ============================================================================
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 5/5: Installing git"
echo "════════════════════════════════════════════════════════════"
echo ""

if command -v git &> /dev/null; then
    echo "✅ git already installed"
    git --version
else
    echo "📥 Installing git..."
    brew install git
    echo "✅ git installed successfully"
fi

echo ""

# ============================================================================
# Bootstrap Complete
# ============================================================================
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║    ✅ Bootstrap Complete!                                 ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📝 Installed components:"
echo "   • Homebrew:    $(brew --version | head -n1)"
echo "   • mise:        $(mise --version)"
echo "   • Node.js:     $(node --version)"
echo "   • pnpm:        $(pnpm --version)"
echo "   • Claude Code: $(claude --version 2>/dev/null || echo 'installed')"
echo "   • git:         $(git --version)"
echo ""
echo "🎯 Next steps:"
echo ""
echo "  1. Clone your setup repository:"
echo "     git clone https://github.com/u88803494/my-mac-dev-setup.git"
echo "     cd mac-dev-setup"
echo ""
echo "  2. Let Claude Code complete the setup (AI-powered):"
echo "     claude 'Read SETUP_PROMPT.md and execute it'"
echo ""
echo "  3. Or for step-by-step guidance:"
echo "     claude 'Read SETUP_PROMPT.md and guide me through each step'"
echo ""
echo "  4. Or use traditional scripts (if AI unavailable):"
echo "     ./scripts/zsh.sh"
echo "     ./scripts/dev-tools.sh"
echo "     ./scripts/apps.sh"
echo ""
echo "💡 Tip: Restart your terminal after Claude Code completes setup"
echo ""
