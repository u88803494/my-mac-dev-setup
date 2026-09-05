# Mac 開發環境設定 - 專案概述

> 最後校對：2026-09-05（配合 feat/new-mac-migration 這次架構轉型同步更新）

## 專案目的
新 macOS 機器的開發環境配置自動化。適用場景：換新公司、換新筆電、重裝系統。

**目標使用者**：Henry Lee (u88803494) 的個人 macOS 開發環境

## 兩階段架構（AI-first，這是目前的核心設計）

1. **`bootstrap.sh`**（人類手動跑一次）— 最小化安裝：Homebrew → Claude Code
   （brew cask）→ mise + Node.js + pnpm → git。目的只是讓 Claude Code 能跑起來。
2. **`SETUP_PROMPT.md`**（AI 主導，**主要路徑**）— clone 這個 repo 後，讓 Claude
   Code 讀這份檔案自主完成剩下的設定（shell、dotfiles、Brewfile、系統偏好）。
   典型觸發：`claude "Read MIGRATION_PLAN.md and SETUP_PROMPT.md, then execute the setup"`

`setup.sh`（傳統手動腳本，依序呼叫 `scripts/*.sh`）是**備援路徑**，給 AI 不可用
時使用，不是主線。

**`MIGRATION_PLAN.md`** 是換機時的主計劃書，涵蓋遷移前檢查（未推送的 repo、秘密
收攏、軟體反啟用）、技術債清單（哪些東西刻意不帶到新機）、新機安裝順序、驗收
清單。`SETUP_PROMPT.md` 開頭就要求先讀這份文件。

## 核心規則

- **版本管理只用 mise，不裝 nvm**——舊機曾經 nvm/mise 並存，互相干擾。
  這條規則寫在 `SETUP_PROMPT.md` 開頭、`Brewfile` 註解、`scripts/node.sh`
  三處。**若這份記憶檔的其他內容與此規則衝突，以規則為準，記憶可能是舊的。**
- **`Brewfile` 是套件的單一事實來源**（CLI 工具 + GUI cask + VS Code
  extensions），一律 `brew bundle --file=Brewfile`，不個別 `brew install`。
  `Brewfile.old-machine` 只是舊機快照參考，不是拿來安裝用的。
- **Claude Code 只用 brew cask 裝**（`bootstrap.sh` 已改），不要再用
  `npm install -g @anthropic-ai/claude-code`——兩份 binary 會版本漂移。

## 安裝內容

### 核心環境
- **Homebrew** — 套件管理
- **mise** + **Node.js LTS** + **pnpm** — JavaScript 執行環境（取代 nvm）
- **Zsh** + **Oh My Zsh** + **Powerlevel10k** — Shell 環境
- **Git 工具鏈** — git, gh, git-delta
- **現代化 CLI 工具** — eza, zoxide, fzf

### GUI 應用程式（全部透過 Brewfile）
iTerm2、VS Code、Claude Code、Chrome、Firefox、Obsidian、Postman、Signal、
Adguard、NordVPN、AlDente、MonitorControl、Cold Turkey Blocker、IINA、
qBittorrent、Microsoft Office 等——完整清單見 `Brewfile`。

### 可選項目（Brewfile 內註解，需要再手動解開）
`olets/tap`、`yarn`、`warp`、`antigravity`、`hotovo-aider-desk`、`macfuse`、
`steam`、`downie`、`chatgpt`、`claude`(Desktop)、`openings-mcp`

## 設計理念

### 模組化架構
- 每個腳本只負責一件事，`SETUP_PROMPT.md` 直接呼叫腳本而非複製邏輯
  （避免兩份實作分岔）
- 失敗隔離，可單獨執行

### 不包含的內容
- VS Code 擴充套件**清單**雖已匯出到 `config/vscode/`，但套用與否仍由使用者決定
- 詳細的 IDE 配置

## 已知會過時的地方
`.serena/memories/` 這幾份記憶檔本身可能落後於 repo 實際內容——每次重大架構
變更後應該回來同步這幾份檔案，而不是只改 `README.md`/`MIGRATION_PLAN.md`。
