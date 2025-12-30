# 任務完成檢查清單

在此專案中完成任務時，遵循以下指南：

## 腳本開發

### 1. 程式碼品質
- [ ] 腳本遵循 bash 風格慣例（見 `code_style_and_conventions.md`）
- [ ] 包含 `#!/bin/bash` shebang
- [ ] 使用 `set -e` 進行錯誤處理
- [ ] 描述性標頭註解說明用途
- [ ] 一致使用 emoji 表示狀態訊息
- [ ] 冪等（可安全重複執行）

### 2. 測試
- [ ] 單獨測試腳本：`./scripts/new-script.sh`
- [ ] 透過主安裝器測試：`./setup.sh`
- [ ] 測試清理：`./scripts/cleanup.sh` 然後重新安裝
- [ ] 在 Intel 和 Apple Silicon 上驗證（如適用）
- [ ] 檢查適當的錯誤訊息

### 3. 文檔
- [ ] 更新 README.md：
  - 安裝內容區段
  - 快速開始說明
  - 目錄結構
  - 模組化使用區段
- [ ] 更新 cleanup.sh 以移除新安裝
- [ ] 如需要添加疑難排解區段

### 4. 整合
- [ ] 以正確順序添加腳本到 `setup.sh`
- [ ] 更新 `setup.sh` 輸出中的步驟編號
- [ ] 設定執行權限：`chmod +x scripts/new-script.sh`
- [ ] 測試相依鏈（什麼必須在之前/之後執行）

## 配置變更

### 1. iTerm2 配置
- [ ] 變更自動同步到 `config/iterm2/com.googlecode.iterm2.plist`
- [ ] 驗證同步：`defaults read com.googlecode.iterm2 PrefsCustomFolder`
- [ ] 無需手動操作（自動同步）

### 2. SuperClaude 設定
- [ ] 更新 `~/.claude/settings.json`
- [ ] 備份到 repo：`cp ~/.claude/settings.json config/claude/`
- [ ] 測試恢復：`cp config/claude/settings.json ~/.claude/`
- [ ] 提交變更到 git

### 3. Git 配置
- [ ] 測試個人範本：`./git/setup-git.sh`（選項 1）
- [ ] 測試工作範本：`./git/setup-git.sh`（選項 2）
- [ ] 測試手動配置：`./git/setup-git.sh`（選項 3）
- [ ] 驗證套用的配置：`git config --global --list`

## README 更新

- [ ] 準確的安裝說明
- [ ] 更新的目錄結構（如果新增/移除檔案）
- [ ] 版本號當前（Node.js, SuperClaude 等）
- [ ] 連結正常（內部檔案參考、外部 URL）
- [ ] FAQ 區段更新（如發現新問題）
- [ ] 範例已測試且準確

## Git 提交

### 提交前
- [ ] 檢視變更：`git diff`
- [ ] 暫存適當的檔案：`git add <files>`
- [ ] 檢查狀態：`git status`
- [ ] 驗證無敏感資料（API keys、個人資訊）

### 提交訊息
- [ ] 清楚、描述性的訊息
- [ ] 遵循現有風格（見 `git log`）
- [ ] 參考 issue/PR（如適用）

### 提交後
- [ ] 推送到 GitHub：`git push`
- [ ] 在 GitHub 網頁介面驗證
- [ ] 更新任何連結的文檔

## 特殊考量

### 添加新工具時

**核心工具**（自動安裝）：
1. [ ] 添加到適當的 `scripts/*.sh` 檔案
2. [ ] 添加到 `cleanup.sh` 移除區段
3. [ ] 更新 README「安裝內容」區段
4. [ ] 驗證它是現有配置的相依項

**可選工具**（文檔說明）：
1. [ ] 添加到 README「可選組件」區段
2. [ ] 包含安裝說明
3. [ ] 說明配置需求
4. [ ] 如果設定複雜則添加到 FAQ

### 移除功能時
1. [ ] 從所有腳本中移除
2. [ ] 從 cleanup.sh 中移除
3. [ ] 更新 README（從所有區段移除）
4. [ ] 檢查破壞的相依性
5. [ ] 更新任何相關文檔
6. [ ] 刪除相關配置檔案

### 變更設計決策時
1. [ ] 更新 `design_decisions.md` memory
2. [ ] 更新受影響的腳本
3. [ ] 用新方法更新 README
4. [ ] 更新相關文檔
5. [ ] 徹底測試（舊方法可能有相依者）

## 驗證命令

進行變更後執行這些：

```bash
# 語法檢查
bash -n ./scripts/your-script.sh

# 權限檢查
ls -lh scripts/

# 測試個別腳本
./scripts/your-script.sh

# 完整整合測試
./scripts/cleanup.sh
./setup.sh

# 驗證安裝
brew --version
pnpm --version  
node --version
git --version
# （適當地添加其他工具）
```

## 無需 Linting/Formatting

此專案**不使用**自動化 linting 或 formatting 工具：
- 不需要 shellcheck（雖然建議遵循最佳實踐）
- 沒有 prettier/formatting
- 對照風格指南的手動程式碼審查

風格一致性透過以下維持：
- 手動程式碼審查
- 遵循現有腳本的範例
- 參考 `code_style_and_conventions.md`

## 測試環境

**主要測試平台**：
- macOS (Darwin)
- Apple Silicon (arm64) 和 Intel (x86_64)
- Zsh shell

**不支援**：
- Linux（設計決策：僅 macOS）
- 其他 shell（bash 腳本針對 zsh 環境）
