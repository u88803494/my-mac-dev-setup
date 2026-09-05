#!/bin/bash
#
# Mac Development Environment Setup
# ==================================
# 新機一鍵配置（傳統腳本路線）
#
# AI 路線請改用：claude "Read SETUP_PROMPT.md and execute it"
# 完整遷移流程（含遷移前的準備）請見：MIGRATION_PLAN.md

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║    🚀 Mac Development Environment Setup                    ║"
echo "║                                                            ║"
echo "║    將安裝與設定：                                          ║"
echo "║    • Homebrew + Brewfile（CLI 工具 + GUI apps）            ║"
echo "║    • mise + Node.js（不使用 nvm）                          ║"
echo "║    • Zsh + Oh My Zsh + Powerlevel10k                      ║"
echo "║    • dotfiles（.zshrc / .gitconfig / .p10k.zsh）          ║"
echo "║    • zsh-scripts 自訂 aliases                              ║"
echo "║    • iTerm2 偏好設定                                       ║"
echo "║    • macOS 系統偏好設定                                    ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "⚠️  執行前請先確認 MIGRATION_PLAN.md §1 的遷移前檢查已完成。"
echo ""

read -p "開始安裝？ (y/N): " -n 1 -r
echo
[[ $REPLY =~ ^[Yy]$ ]] || { echo "已取消。"; exit 0; }

step() {
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "📦 Step $1/7: $2"
    echo "════════════════════════════════════════════════════════════"
    echo ""
}

step 1 "Homebrew + Brewfile"
bash "$SCRIPT_DIR/scripts/brew.sh"

step 2 "mise + Node.js"
bash "$SCRIPT_DIR/scripts/node.sh"

step 3 "Zsh + Oh My Zsh + Powerlevel10k"
bash "$SCRIPT_DIR/scripts/zsh.sh"

step 4 "還原 dotfiles"
bash "$SCRIPT_DIR/scripts/restore-dotfiles.sh"

step 5 "zsh-scripts symlinks"
bash "$SCRIPT_DIR/scripts/symlink-zsh.sh"

step 6 "iTerm2 偏好設定"
bash "$SCRIPT_DIR/scripts/iterm2-config.sh"

step 7 "macOS 系統偏好設定"
bash "$SCRIPT_DIR/scripts/macos-defaults.sh"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║    ✅ 安裝完成                                             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📝 接下來手動處理："
echo ""
echo "  1. 秘密檔："
echo "     cp config/shell/.zshrc.local.example ~/.zshrc.local && chmod 600 ~/.zshrc.local"
echo "     # 從密碼管理器填入 API keys"
echo ""
echo "  2. Git 與 SSH（三步驟依序做，第 2 步沒過不要做第 3 步）："
echo "     bash git/setup-git.sh"
echo "     ssh-keygen -t ed25519 -C \"u88803494@gmail.com\""
echo "     gh auth login && gh ssh-key add ~/.ssh/id_ed25519.pub"
echo "     # 驗證：ssh -T git@github.com 且能 git pull 一個私有 repo 成功"
echo "     #       確認成功後，才去 GitHub Settings → SSH Keys 移除舊機那把 key"
echo ""
echo "  3. VS Code 設定："
echo "     cp config/vscode/settings.json ~/Library/Application\\ Support/Code/User/"
echo "     # extensions 已由 Brewfile 安裝"
echo ""
echo "  4. SuperClaude（選用）："
echo "     pipx install SuperClaude && SuperClaude install"
echo ""
echo "  6. 重開終端機，然後跑 MIGRATION_PLAN.md §5 的驗收清單"
echo ""
