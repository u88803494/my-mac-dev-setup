# 設計決策與理由

> 最後校對：2026-09-05——下面標記「⚠️ 已過時」的段落是決策當時的紀錄，
> 保留是為了理解演變過程，但**內容本身不再反映現況**，不要照著執行。

## 0. AI-first 兩階段架構（決策日期：2026-09-05，取代下方部分舊決策）

**決策**：`bootstrap.sh`（最小化：Homebrew → Claude Code → mise/Node → git）
→ `SETUP_PROMPT.md`（AI 主導剩餘設定）成為主線；`setup.sh` 降級為備援路徑。

**理由**：使用者換機後主要就是直接裝 Claude Code CLI，讓它自主讀
`SETUP_PROMPT.md` 執行，而不是自己跑傳統腳本。

**連帶決策**：
- 版本管理只用 **mise**，不裝 **nvm**（下方「核心環境」提到 nvm 的地方已過時）
- `Brewfile` 取代個別 `brew install` 呼叫，成為套件的單一事實來源
- Claude Code 改用 `brew cask` 安裝，不用 `npm install -g`
- VS Code extensions **已經**匯出到 `config/vscode/extensions.txt`（見下方
  第 10 點「不管理 VS Code 擴充套件」——那則決策已被推翻，現在有匯出但
  安裝與否仍由使用者自行決定，不會被 Brewfile 強制套用）
- Python 工具 `pipx` 已在 Brewfile 取消註解（第 6 點已過時，見下方標註）

## 架構決策

### 1. 模組化腳本設計（核心理念）
**決策**：分離的腳本各自負責一個組件，而非單一巨大安裝器

**理由**：
- **支援部分安裝**：使用者可以只安裝 Zsh 而不裝 Node.js
- **失敗隔離**：一個腳本失敗不會破壞整個安裝
- **更易維護**：每個腳本有單一、清楚的目的
- **彈性**：腳本可以單獨執行或透過 `setup.sh` 編排

**實作**：
- `scripts/` 中的每個腳本都是獨立且可執行的
- `setup.sh` 以正確順序呼叫它們
- 所有腳本都是冪等的（可安全重複執行）

### 2. 核心 vs 可選工具分離
**決策**：自動安裝核心工具，文檔說明可選工具

**核心工具**（透過腳本自動安裝）：
- 基本開發環境（Homebrew, Node.js, Zsh）
- 配置檔案依賴的工具（eza, zoxide, git-delta）
- 無爭議的選擇

**可選工具**（在 README 中說明）：
- 特定場景工具（SuperClaude）
- 個人偏好工具
- 需要 API keys 或額外設定的工具

**理由**：在便利性和彈性間取得平衡

### 3. 僅 macOS，不支援 Linux
**決策日期**：2025-10-23

**理由**：
- 主要使用案例是個人 macOS 機器
- 不同的套件管理器和系統行為
- 會為最小效益增加複雜度
- Linux 設定通常差異大到需要獨立專案

**影響**：
- 沒有 Linux 的 OS 偵測
- 以 Homebrew 為中心的套件管理
- macOS 特定工具（iTerm2, `defaults write`）

### 4. SuperClaude 安裝策略變更
**決策日期**：2025-10-23

**舊方式**：自訂 `scripts/superclaude-setup.sh` 包裝腳本

**新方式**：直接使用官方 SuperClaude CLI
```bash
pipx upgrade SuperClaude && SuperClaude install
```

**理由**：
- 官方 CLI 提供互動式組件選擇
- 自動安裝和配置 MCP servers
- 更少的維護負擔（無需追蹤框架變更）
- 更好的使用者體驗與引導式設定

**影響**：
- 移除 `scripts/superclaude-setup.sh`
- 移除 `scripts/tavily-mcp-setup.sh`（現在由 SuperClaude install 處理）
- 只備份個人 `settings.json`，不備份框架組件

### 5. 配置同步策略

#### iTerm2：自動同步
**實作**：使用 macOS `defaults write` 指向 repo 目錄
```bash
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$CONFIG_DIR"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
```

**理由**：
- 雙向同步（iTerm2 中的變更自動儲存到 repo）
- 無需手動備份/恢復
- 單一真實來源

#### SuperClaude：手動設定備份
**實作**：
- 框架透過 `SuperClaude install` 管理
- 只備份 `~/.claude/settings.json` 到 repo

**理由**：
- 框架組件變更頻繁（官方更新）
- 個人設定（權限、API keys、路徑）穩定
- 關注點分離：框架 vs. 使用者偏好

### 6. Python 工具預設註解 ⚠️ 已過時（見上方第 0 點）
`pipx` 現在已在 `Brewfile` 取消註解（SuperClaude 需要）；`uv` 改由
`config/mise/config.toml` 的 mise 全域工具管理，不是 Homebrew。

原始決策紀錄（僅供參考）：
**決策**：在 `brew.sh` + Brewfile 中註解 `pipx` 和 `uv`

**理由**：
- 使用者有 M1 MacBook Air 128GB（空間受限）
- 使用者「有點想學 Python」（尚未必要）
- 目前核心工作流程不需要
- 需要時容易取消註解

**實作**：
```bash
# Python 工具（學習 Python 時取消註解）
# brew install pipx uv
```

### 7. Git 配置範本
**決策**：三層式 Git 配置系統

**選項**：
1. 個人範本（Henry / u88803494@gmail.com）
2. 工作範本（自訂 email 提示）
3. 手動配置

**理由**：
- 個人專案 vs. 工作專案需要不同 email
- 已知場景快速設定（個人）
- 工作環境的彈性
- 支援條件式 includes（可添加工作特定設定）

**進階功能**：
- Git Delta pager（更好的 diff 檢視）
- 條件式 gitconfig includes（工作/個人自動切換）
- 自動設定 remote（git push 自動設定上游）

### 8. 測試用清理腳本
**決策**：用 `cleanup.sh` 對應 `setup.sh`

**目的**：
- 測試安裝流程而不保留安裝
- 開發和迭代腳本
- 驗證冪等行為

**安全功能**：
- 需要明確 "yes" 確認
- 恢復前備份 `.zshrc`
- 保留 Homebrew 本身（可能被其他應用使用）
- 保留帶時間戳的 `.zshrc` 備份

**cleanup.sh 不包含**：
- 不解除安裝 Homebrew（太破壞性）
- 保留 `.zshrc.pre-oh-my-zsh`（原始備份）
- 不碰 git repositories 或個人檔案

### 9. Shell 插件策略
**決策**：連結到獨立的 `zsh-scripts` repo 而非嵌入

**理由**：
- Aliases 和 functions 變更頻繁
- 跨多個專案共享
- 可以獨立更新
- 所有機器的單一來源

**權衡**：需要先手動 clone `zsh-scripts` repo

### 10. 不管理 VS Code 擴充套件 ⚠️ 已過時（見上方第 0 點）
現在 `config/vscode/extensions.txt` + `settings.json` 已匯出進 repo（換機時
省得重新一個個裝），但不透過 Brewfile 強制安裝，安裝與否仍由使用者決定——
原本「太個人化、變動頻繁」的理由依然成立，只是換成「匯出但不強制」的折衷。

原始決策紀錄（僅供參考）：
**決策**：不管理 VS Code 擴充套件

**理由**：
- 高度個人化的偏好
- 變更頻繁
- VS Code 有內建同步
- 使用者偏好手動控制

**替代方案**：使用者可以使用 VS Code Settings Sync

### 11. iTerm2 字型 ⚠️ 部分過時（安裝方式已變）
`font-meslo-lg-nerd-font` 現在由 **Brewfile** 統一安裝（cask），不是
`scripts/zsh.sh`（`zsh.sh` 已改為不重複裝字型，見 codebase_structure.md）。
iTerm2 本身仍需手動選字型，這部分決策不變。

## 未來考量

### 已完成（原本列在「可能的添加」）
- ✅ macOS 系統偏好設定自動化 → `scripts/macos-defaults.sh`
- ✅ Brewfile 用於確切套件版本 → `Brewfile`

### 可能的添加
- 多個環境配置檔（最小、完整、開發特定）

### 明確不計劃
- Linux 支援（需要時獨立專案）
- IDE 特定配置（太個人化）
- 雲端配置同步（git 已足夠）

### 部分調整
- VS Code 擴充套件：清單已匯出（`config/vscode/`），但**不**透過
  Brewfile 強制安裝，見第 10 點
