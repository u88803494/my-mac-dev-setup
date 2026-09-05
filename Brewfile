# Brewfile — 新機目標狀態（curated）
#
# 用法：brew bundle --file=Brewfile
#
# 這份是「新機該有什麼」，不是舊機的原樣快照。
# 舊機原樣快照請看 Brewfile.old-machine。
#
# 註解掉的項目 = 需要時再手動解開，不預設安裝
# （原則：只裝上個月真的用過的東西，見 MIGRATION_PLAN.md §2.3）

# ─────────────────────────────────────────────
# Taps
# ─────────────────────────────────────────────
tap "amikai/tap"          # openings-mcp
# tap "olets/tap"         # 確認：zsh-abbr？目前 formulae 沒裝任何 olets 套件

# ─────────────────────────────────────────────
# 核心開發工具（必裝）
# ─────────────────────────────────────────────
brew "git"
brew "gh"                 # GitHub CLI
brew "git-delta"          # git diff 語法高亮
brew "mise"               # 版本管理器（Node/Python/…）— 取代 nvm
brew "pnpm"               # 主要套件管理器

# ─────────────────────────────────────────────
# Shell 體驗（.zshrc 有依賴，缺了會壞）
# ─────────────────────────────────────────────
brew "eza"                # ls 替代，zsh-scripts 的 t() 需要
brew "zoxide"             # 智慧 cd，.zshrc 的 j alias 需要
brew "fzf"

# ─────────────────────────────────────────────
# 常用 CLI
# ─────────────────────────────────────────────
brew "tree"
brew "tmux"
brew "rclone"             # 雲端同步（設定檔含 token，需另外還原）
brew "ffmpeg"
brew "yt-dlp"
brew "poppler"            # PDF 處理（pdftotext 等）
brew "pipx"               # Python CLI 隔離安裝（SuperClaude 用）

# ─────────────────────────────────────────────
# 已淘汰 — 新機不要裝
# ─────────────────────────────────────────────
# brew "nvm"              # ❌ 與 mise 重複，舊機殘留 885MB／5 個 Node 版本
# brew "autojump"         # ❌ 與 zoxide 重複，.zshrc 未使用
# brew "python@3.13"      # ❌ 交給 mise + uv 管理
# brew "yarn"             # ❓ 專案已全面改用 pnpm，確認還有沒有舊專案需要

# ─────────────────────────────────────────────
# 字型
# ─────────────────────────────────────────────
cask "font-meslo-lg-nerd-font"   # Powerlevel10k 必需

# ─────────────────────────────────────────────
# 終端機與編輯器（必裝）
# ─────────────────────────────────────────────
cask "iterm2"
cask "visual-studio-code"
cask "claude-code"

# ─────────────────────────────────────────────
# 瀏覽器
# ─────────────────────────────────────────────
cask "google-chrome"
cask "firefox"

# ─────────────────────────────────────────────
# 日常應用
# ─────────────────────────────────────────────
cask "obsidian"
cask "postman"
cask "signal"
cask "adguard"
cask "nordvpn"
cask "aldente"                   # 電池充電上限
cask "monitorcontrol"            # 外接螢幕亮度
cask "cold-turkey-blocker"       # 專注／封鎖
cask "iina"
cask "qbittorrent"
cask "microsoft-office"

# ─────────────────────────────────────────────
# 需確認再裝（舊機有，但先別預設）
# ─────────────────────────────────────────────
# cask "amikai/tap/openings-mcp", trusted: true   # 求職 MCP，還在用就解開
# cask "warp"                     # ❓ 已有 iTerm2，二選一
# cask "antigravity"              # ❓ 舊機 .antigravity 佔 504MB
# cask "antigravity-cli"
# cask "hotovo-aider-desk"        # ❓ 舊機 Application Support 佔 849MB
# cask "macfuse"                  # ❓ 確認是哪個工具依賴它
# cask "steam"                    # ❓ 遊戲，確認新機要不要
# cask "downie"                   # ❓ 付費軟體，需確認授權可轉移
# cask "chatgpt"
# cask "claude"                   # Claude Desktop（舊機 Application Support 佔 11GB）

# ─────────────────────────────────────────────
# Homebrew 沒有，需手動安裝
# ─────────────────────────────────────────────
# LINE            → App Store
# pCloud Drive    → https://www.pcloud.com/download-free-online-cloud-file-storage.html
# Xcode           → App Store（❓ 沒做 iOS 開發就只裝 Command Line Tools）
