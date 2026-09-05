#!/bin/bash
#
# Node.js（透過 mise）
# =====================
# ⚠️  舊版本腳本用 nvm，已淘汰。
#     新機一律使用 mise 管理版本，不要再裝 nvm（兩者並存會互相干擾）。

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Node.js via mise"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if ! command -v mise &> /dev/null; then
    echo "📥 安裝 mise..."
    brew install mise
fi

eval "$(mise activate bash)"

# 還原全域版本設定
mkdir -p ~/.config/mise
if [ -f "$SCRIPT_DIR/config/mise/config.toml" ]; then
    if [ -f ~/.config/mise/config.toml ]; then
        echo "⚠️  ~/.config/mise/config.toml 已存在，跳過覆寫"
        echo "   repo 版本內容："
        cat "$SCRIPT_DIR/config/mise/config.toml"
    else
        cp "$SCRIPT_DIR/config/mise/config.toml" ~/.config/mise/config.toml
        echo "✅ 已還原 mise 全域設定"
    fi
fi

echo ""
echo "📥 安裝設定檔中的工具..."
mise install

echo ""
echo "✅ 完成"
mise ls
echo ""
echo "Node:  $(node --version 2>/dev/null || echo '需重開 shell')"
echo "pnpm:  $(pnpm --version 2>/dev/null || echo '由 Brewfile 安裝')"
echo ""
echo "⚠️  確認 nvm 沒有被裝進來：brew list nvm 應該要失敗"
