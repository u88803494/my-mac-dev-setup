#!/bin/bash
#
# Homebrew + Brewfile
# ====================
# 安裝 Homebrew，然後用 Brewfile 一次還原所有 formulae / cask / VS Code 擴充套件
#
# 取代了舊版的 brew.sh（只裝 pnpm）、dev-tools.sh、apps.sh — 全部併入 Brewfile

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Homebrew + Brewfile"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── Homebrew ────────────────────────────────
if command -v brew &> /dev/null; then
    echo "✅ Homebrew 已安裝：$(brew --version | head -n1)"
else
    echo "📥 安裝 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ $(uname -m) == 'arm64' ]]; then
        echo "🔧 加入 PATH（Apple Silicon）..."
        grep -q 'brew shellenv' ~/.zprofile 2>/dev/null \
          || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    echo "✅ Homebrew 安裝完成"
fi

echo ""

# ── Brewfile ────────────────────────────────
if [ ! -f "$SCRIPT_DIR/Brewfile" ]; then
    echo "❌ 找不到 $SCRIPT_DIR/Brewfile"
    exit 1
fi

echo "📥 依 Brewfile 安裝套件..."
echo "   （註解掉的項目不會裝，要裝請先編輯 Brewfile）"
echo ""
brew bundle --file="$SCRIPT_DIR/Brewfile"

echo ""
echo "✅ Brewfile 安裝完成"
echo ""
echo "📝 檢查與 Brewfile 不符的既有套件："
echo "   brew bundle check --file=Brewfile"
echo "   brew bundle cleanup --file=Brewfile    # 列出多餘套件（加 --force 才會真的移除）"
