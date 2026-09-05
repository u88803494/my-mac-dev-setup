#!/bin/bash

# Zsh + Oh My Zsh + Powerlevel10k Installation Script
# ======================================================
#
# 這支腳本只負責「裝軟體」（OMZ、p10k 主題、plugin repo）。
# 不會修改 ~/.zshrc 內容——那是 restore-dotfiles.sh 的職責
# （直接還原 config/shell/.zshrc 整份檔案）。兩邊都去改 .zshrc
# 會互相覆蓋、順序打架，所以職責切開。

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐚 Installing Zsh + Oh My Zsh + Powerlevel10k"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ─────────────────────────────────────────────
# Zsh：一律使用系統內建 /bin/zsh
# ─────────────────────────────────────────────
# 不透過 Homebrew 裝 zsh — 現代 macOS 內建的 /bin/zsh 已經是預設 shell、
# 已在 /etc/shells 內。改裝一份 Homebrew zsh 只會讓 chsh 的目標路徑
# 變成不在 /etc/shells 裡的 /opt/homebrew/bin/zsh，反而製造問題。
ZSH_BIN="$(command -v zsh)"
echo "使用 zsh：$ZSH_BIN"
zsh --version

# 設為預設 shell（若還不是）
if [ "$SHELL" != "$ZSH_BIN" ]; then
    if ! grep -qxF "$ZSH_BIN" /etc/shells; then
        echo "⚠️  $ZSH_BIN 不在 /etc/shells 內，需要 sudo 權限加入"
        echo "    這一步需要輸入密碼，且不能在背景/非互動環境執行："
        echo "    sudo sh -c 'echo \"$ZSH_BIN\" >> /etc/shells'"
        echo "⏭  略過自動加入，請使用者本人手動執行上面那行後再跑一次 chsh"
    else
        echo "🔧 設定 zsh 為預設 shell..."
        echo "    ⚠️  chsh 會要求輸入『目前登入使用者』的密碼——這一步"
        echo "    必須由使用者本人在有 TTY 的終端機裡手動完成，AI 不要"
        echo "    嘗試在背景執行，否則會卡住等輸入或直接失敗。"
        chsh -s "$ZSH_BIN"
        echo "✅ Zsh 已設為預設 shell（重啟終端機生效）"
    fi
else
    echo "✅ zsh 已經是預設 shell"
fi

echo ""

# ─────────────────────────────────────────────
# Oh My Zsh
# ─────────────────────────────────────────────
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh already installed"
else
    echo "📥 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh installed successfully"
fi

echo ""

# ─────────────────────────────────────────────
# Powerlevel10k 主題
# ─────────────────────────────────────────────
# 字型（font-meslo-lg-nerd-font）由 Brewfile 統一安裝，這裡不重複裝。
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
if [ -d "$P10K_DIR" ]; then
    echo "✅ Powerlevel10k already installed"
else
    echo "📥 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    echo "✅ Powerlevel10k installed successfully"
fi

echo ""

# ─────────────────────────────────────────────
# Zsh plugins（git clone 進 $ZSH_CUSTOM/plugins/）
# ─────────────────────────────────────────────
# 舊機實測這兩個 plugin 是 git clone 進 custom/plugins，不是透過
# Homebrew 安裝——OMZ 的 plugins=() 陣列只會在 $ZSH/plugins 與
# $ZSH_CUSTOM/plugins 底下找同名目錄，不會自動抓 brew 的 share 路徑。
clone_plugin() {
    local name="$1" url="$2"
    if [ -d "$ZSH_CUSTOM/plugins/$name" ]; then
        echo "✅ $name already installed"
    else
        echo "📥 Installing $name..."
        git clone --depth=1 "$url" "$ZSH_CUSTOM/plugins/$name"
    fi
}

clone_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
clone_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"

echo ""

# ─────────────────────────────────────────────
# p10k 設定檔（restore-dotfiles.sh 通常已處理，這裡只是防呆）
# ─────────────────────────────────────────────
if [ -f "$HOME/.p10k.zsh" ]; then
    echo "✅ .p10k.zsh 已存在"
elif [ -f "$SCRIPT_DIR/config/.p10k.zsh" ]; then
    cp "$SCRIPT_DIR/config/.p10k.zsh" "$HOME/.p10k.zsh"
    echo "✅ 已複製 .p10k.zsh"
fi

echo ""
echo "✅ Zsh 環境安裝完成"
echo ""
echo "📝 .zshrc 內容（ZSH_THEME / plugins=(...) 等）由"
echo "   scripts/restore-dotfiles.sh 還原，不在這支腳本處理。"
echo "   重啟終端機或 source ~/.zshrc 生效。"
