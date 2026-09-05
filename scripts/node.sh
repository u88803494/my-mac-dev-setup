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
#
# repo 的 config/mise/config.toml 是單一事實來源（例如含 uv）。
# bootstrap.sh 會先跑 `mise use -g node@lts` 建立一份只有 node/pnpm 的
# ~/.config/mise/config.toml——如果這裡遇到已存在就跳過，repo 版本的
# 內容（uv 等）就永遠不會被套用，且不會有任何錯誤訊息。
# 所以這裡改成：一律以 repo 版本覆寫，既有檔案只在第一次備份一次。
mkdir -p ~/.config/mise
if [ -f "$SCRIPT_DIR/config/mise/config.toml" ]; then
    if [ -f ~/.config/mise/config.toml ] && [ ! -f ~/.config/mise/config.toml.pre-migration ]; then
        cp ~/.config/mise/config.toml ~/.config/mise/config.toml.pre-migration
        echo "💾 既有設定已備份為 config.toml.pre-migration"
    fi
    cp "$SCRIPT_DIR/config/mise/config.toml" ~/.config/mise/config.toml
    echo "✅ 已套用 repo 版本的 mise 全域設定"
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
