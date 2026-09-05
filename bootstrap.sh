#!/bin/bash

# Mac Development Environment Bootstrap
# =======================================
# Minimal setup to enable Claude Code AI-powered configuration
# This script installs: Homebrew → Claude Code → mise/Node.js → git

set -e  # Exit on error

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║    🚀 Mac Dev Environment Bootstrap                       ║"
echo "║    Installing: Homebrew → Claude Code → mise/Node → git   ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# ============================================================================
# Step 1: Install Homebrew
# ============================================================================
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 1/4: Installing Homebrew"
echo "════════════════════════════════════════════════════════════"
echo ""

if command -v brew &> /dev/null; then
    echo "✅ Homebrew already installed"
    brew --version
else
    echo "📥 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "✅ Homebrew installed successfully"
fi

# 不論剛裝好還是本來就有，都確保 shellenv 寫進 ~/.zprofile
# （只 eval 不寫檔的話,PATH 只在這個 subshell 生效,新開的終端機分頁會找不到 brew/mise/claude）
if [[ $(uname -m) == 'arm64' ]]; then
    grep -q 'brew shellenv' ~/.zprofile 2>/dev/null \
      || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo ""

# ============================================================================
# Step 2: Install Claude Code
# ============================================================================
# 用 brew cask 裝,不依賴 mise/Node — Claude Code 應該是這裡最先能跑起來的工具,
# 不需要等 Step 3 的 mise/Node 裝完才能啟動。
# （不要用 npm install -g @anthropic-ai/claude-code — 那樣會產生第二份獨立的
#   claude binary,跟這裡的 cask 版本互相打架,版本各自升級、PATH 解析看運氣）
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 2/4: Installing Claude Code"
echo "════════════════════════════════════════════════════════════"
echo ""

if command -v claude &> /dev/null; then
    echo "✅ Claude Code already installed"
    claude --version
else
    echo "📥 Installing Claude Code via Homebrew cask..."
    brew install --cask claude-code
    echo "✅ Claude Code installed successfully"
fi

echo ""

# ============================================================================
# Step 3: Install mise + Node.js + pnpm
# ============================================================================
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 3/4: Installing mise + Node.js LTS + pnpm"
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

eval "$(mise activate bash)"

echo "📥 Installing Node.js LTS..."
mise use -g node@lts

echo "📥 Installing pnpm..."
mise use -g pnpm@latest

echo "✅ Node.js $(node --version) installed via mise"
echo "✅ pnpm $(pnpm --version) installed via mise"

echo ""

# ============================================================================
# Step 4: Install git
# ============================================================================
echo "════════════════════════════════════════════════════════════"
echo "📦 Step 4/4: Installing git"
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
echo "   • Claude Code: $(claude --version 2>/dev/null || echo 'installed')"
echo "   • mise:        $(mise --version)"
echo "   • Node.js:     $(node --version)"
echo "   • pnpm:        $(pnpm --version)"
echo "   • git:         $(git --version)"
echo ""
echo "🎯 Next steps:"
echo ""
echo "  1. Clone your setup repository:"
echo "     git clone https://github.com/u88803494/my-mac-dev-setup.git"
echo "     cd my-mac-dev-setup"
echo ""
echo "  2. Let Claude Code complete the setup (AI-powered):"
echo "     claude 'Read MIGRATION_PLAN.md and SETUP_PROMPT.md, then execute the setup'"
echo ""
echo "  3. Or for step-by-step guidance:"
echo "     claude 'Read SETUP_PROMPT.md and guide me through each step'"
echo ""
echo "  4. Or use traditional scripts (if AI unavailable):"
echo "     ./setup.sh"
echo ""
echo "💡 Tip: 若這個 terminal session 是全新裝的 Homebrew,開新分頁再繼續,"
echo "   確保 ~/.zprofile 的 PATH 設定已生效。"
echo ""
