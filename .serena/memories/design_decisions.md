# 設計決策與理由

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

### 6. Python 工具預設註解
**決策**：在 `dev-tools.sh` 中註解 `pipx` 和 `uv`

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

### 10. 不管理 VS Code 擴充套件
**決策**：不管理 VS Code 擴充套件

**理由**：
- 高度個人化的偏好
- 變更頻繁
- VS Code 有內建同步
- 使用者偏好手動控制

**替代方案**：使用者可以使用 VS Code Settings Sync

### 11. iTerm2 字型建議（非自動化）
**決策**：說明字型需求，但不在 iTerm2 中自動選擇

**建議字型**：MesloLGS NF（給 Powerlevel10k 用）

**理由**：
- 透過 Zsh 腳本自動安裝
- 字型選擇是個人偏好
- iTerm2 可能有現有字型設定
- 手動選擇很簡單（一次性設定）

**文檔**：在 README 提示區段註記

## 未來考量

### 可能的添加
- macOS 系統偏好設定自動化（需要研究）
- Brewfile 用於確切套件版本
- 多個環境配置檔（最小、完整、開發特定）

### 明確不計劃
- Linux 支援（需要時獨立專案）
- IDE 特定配置（太個人化）
- 自動化 VS Code 擴充套件管理
- 雲端配置同步（git 已足夠）
