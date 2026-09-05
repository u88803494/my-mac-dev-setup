#!/bin/bash
#
# macOS 系統偏好設定
# ===================
# 依舊機（MacBook Air M1 / macOS 26.6.2）實際設定整理，2026-09-05
#
# 用法：bash scripts/macos-defaults.sh
# 執行後需重啟 Dock / Finder（腳本結尾會自動做）

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🖥  套用 macOS 系統偏好設定"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ─────────────────────────────────────────────
# 外觀（舊機實際值：Dark）
# ─────────────────────────────────────────────
defaults write -g AppleInterfaceStyle -string "Dark"

# ─────────────────────────────────────────────
# Dock（舊機實際值：autohide=1, tilesize=64）
# ─────────────────────────────────────────────
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 64
defaults write com.apple.dock show-recents -bool false      # 新增：不顯示最近使用

# ─────────────────────────────────────────────
# Finder（舊機實際值：路徑列與狀態列開啟、清單檢視）
# ─────────────────────────────────────────────
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"   # 清單檢視
defaults write -g AppleShowAllExtensions -bool true                   # 新增：顯示副檔名
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"   # 新增：搜尋預設為當前資料夾

# ─────────────────────────────────────────────
# 鍵盤（舊機為系統預設值，這裡調快，不想要就註解掉）
# ─────────────────────────────────────────────
defaults write -g KeyRepeat -int 2            # 重複速度（越小越快，預設 6）
defaults write -g InitialKeyRepeat -int 15    # 重複前延遲（預設 25）
defaults write -g ApplePressAndHoldEnabled -bool false   # 長按顯示重音選單 → 關閉，改為連續輸入

# ─────────────────────────────────────────────
# 螢幕截圖（舊機為預設丟桌面，導致桌面堆了 20+ 張截圖）
# ─────────────────────────────────────────────
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ─────────────────────────────────────────────
# 套用
# ─────────────────────────────────────────────
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo ""
echo "✅ 完成。部分設定需重新登入才會生效。"
echo ""
echo "⚠️  以下需手動在「系統設定」中處理，無法用 defaults 可靠設定："
echo "   • FileVault 開啟"
echo "   • Touch ID"
echo "   • 觸控板手勢與輕觸點按"
echo "   • Time Machine 備份目的地"
echo "   • 「尋找」與 iCloud 同步項目"
