#!/bin/bash
#
# 還原 dotfiles
# ==============
# 把 config/shell/ 底下的設定檔複製到家目錄。
# 既有檔案會先備份成 <檔名>.pre-migration。
#
# ⚠️  .zshrc.local（API keys）不在這裡處理 — 它不進 git。
#     請 cp config/shell/.zshrc.local.example ~/.zshrc.local 後手動填值。

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$SCRIPT_DIR/config/shell"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔗 還原 dotfiles"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

restore() {
    local name="$1"
    local src="$SRC/$name"
    local dst="$HOME/$name"

    [ -f "$src" ] || { echo "⏭  跳過 $name（repo 內不存在）"; return; }

    if [ -f "$dst" ]; then
        if diff -q "$src" "$dst" > /dev/null 2>&1; then
            echo "✅ $name 已是最新"
            return
        fi
        # 只在第一次備份 — 若這支腳本被重跑第二次（例如今天跑一半、
        # 明天繼續，中途又手動改過家目錄的檔案），固定檔名的備份會被
        # 覆蓋掉，永久遺失最原始的版本。.pre-migration 已存在就不再動它。
        if [ ! -f "$dst.pre-migration" ]; then
            cp "$dst" "$dst.pre-migration"
            echo "💾 既有 $name 已備份為 $name.pre-migration"
        else
            echo "ℹ️  $name.pre-migration 已存在，保留原始備份不覆蓋"
        fi
    fi

    cp "$src" "$dst"
    echo "✅ 已還原 $name"
}

restore .zshrc
restore .zprofile
restore .gitconfig
restore .gitignore_global

echo ""

# Powerlevel10k 設定
if [ -f "$SCRIPT_DIR/config/.p10k.zsh" ]; then
    if [ -f "$HOME/.p10k.zsh" ]; then
        echo "✅ .p10k.zsh 已存在，跳過"
    else
        cp "$SCRIPT_DIR/config/.p10k.zsh" "$HOME/.p10k.zsh"
        echo "✅ 已還原 .p10k.zsh"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 手動步驟"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  1. 建立秘密檔："
echo "     cp $SRC/.zshrc.local.example ~/.zshrc.local"
echo "     chmod 600 ~/.zshrc.local"
echo "     # 然後從密碼管理器填入 MORPH_API_KEY / TAVILY_API_KEY / SUPABASE_ACCESS_TOKEN"
echo ""
echo "  2. 確認 git email："
echo "     git config --get user.email"
echo ""
echo "  3. 重開終端機或 source ~/.zshrc"
