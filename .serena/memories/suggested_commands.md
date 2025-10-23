# 常用命令建議

## 安裝命令

### 完整安裝
```bash
# 完整安裝（建議新機器使用）
./setup.sh
```

### 模組化安裝
```bash
# 核心環境
./scripts/brew.sh          # Homebrew + pnpm
./scripts/node.sh          # nvm + Node.js
./scripts/zsh.sh           # Zsh 環境

# 開發工具
./scripts/dev-tools.sh     # Git 工具鏈 + 現代化 CLI
./scripts/apps.sh          # GUI 應用程式

# 配置
./scripts/iterm2-config.sh # iTerm2 同步
./git/setup-git.sh         # Git 配置（互動式）
```

### 可選組件
```bash
# SuperClaude Framework + MCP servers
pipx install SuperClaude
pipx upgrade SuperClaude
SuperClaude install        # 互動式選擇組件

# 設定 MCP servers 的 API keys（如果需要）
export TAVILY_API_KEY="your-key"
export TWENTYFIRST_API_KEY="your-key"
echo 'export TAVILY_API_KEY="your-key"' >> ~/.zshrc
echo 'export TWENTYFIRST_API_KEY="your-key"' >> ~/.zshrc
```

## 測試命令

### 清理以重新測試
```bash
# 移除所有已安裝的組件（用於測試）
./scripts/cleanup.sh

# 然後重新執行安裝
./setup.sh
```

### 驗證命令
```bash
# 檢查安裝
brew --version
pnpm --version
node --version
git --version
eza --version
zoxide --version

# 檢查 Git 配置
git config --global user.name
git config --global user.email

# 檢查 SuperClaude
SuperClaude --version
```

## 配置備份

### iTerm2
```bash
# 配置會自動同步到 config/iterm2/
# 無需手動備份

# 手動檢查同步位置
defaults read com.googlecode.iterm2 PrefsCustomFolder
```

### SuperClaude 設定
```bash
# 備份當前設定到 repo
cp ~/.claude/settings.json ~/personal/mac-dev-setup/config/claude/

# 從 repo 恢復設定
cp ~/personal/mac-dev-setup/config/claude/settings.json ~/.claude/
```

### Zsh 配置
```bash
# 編輯自訂 aliases（在獨立 repo）
cd ~/personal/zsh-scripts
vim custom.plugin.zsh
git commit && git push

# 重新載入配置
source ~/.zshrc
```

## Git 操作

### 設定 Git 配置
```bash
./git/setup-git.sh
# 選擇：1) 個人  2) 工作  3) 手動
```

### 提交變更
```bash
# 標準流程
git add .
git commit -m "描述"
git push

# 添加新檔案
git add config/claude/settings.json
git commit -m "更新 Claude 設定"
```

## 有用的 Shell 函式（安裝後可用）

這些在設定完成後會自動可用：

```bash
# 樹狀檢視並複製到剪貼簿
t                          # 當前目錄樹

# 智能目錄跳轉（從使用中學習）
j <dir>                    # 跳到常用目錄

# 快速命令（來自 zsh-scripts repo）
c                          # 啟動 Claude Code
cls                        # 清除畫面
uuid                       # 生成 UUID（小寫，複製到剪貼簿）
```

## macOS 特定命令

### Homebrew
```bash
# 更新 Homebrew
brew update

# 升級套件
brew upgrade

# 列出已安裝的套件（僅直接安裝）
brew leaves

# 搜尋套件
brew search <名稱>
```

### 系統資訊
```bash
# 檢查架構（Intel vs Apple Silicon）
uname -m                   # arm64 = Apple Silicon, x86_64 = Intel

# macOS 版本
sw_vers
```

## 疑難排解

### Powerlevel10k 配置
```bash
# 重新執行配置精靈
p10k configure

# 使用 repo 的預先配置版本
# （已自動套用）
```

### iTerm2 配置未載入
```bash
./scripts/iterm2-config.sh
# 然後重啟 iTerm2
```

### Zsh Scripts 找不到
```bash
# 先 clone zsh-scripts repo
git clone https://github.com/u88803494/zsh-scripts.git ~/personal/zsh-scripts

# 然後執行 symlink 腳本
./scripts/symlink-zsh.sh
```

### SuperClaude 問題
```bash
# 檢查版本
SuperClaude --version

# 重新安裝組件
SuperClaude install

# 檢查 MCP server 狀態（在 Claude Code 中）
# 查看是否有缺少 API keys 的錯誤
```

## 開發工作流程

### 進行變更
1. 編輯腳本或配置
2. 用 `./scripts/cleanup.sh` 然後個別腳本測試
3. 提交變更到 git
4. 推送到 GitHub

### 添加新工具
1. 決定：核心（scripts/）或可選（僅 README.md）
2. 添加到適當的腳本（例如 `dev-tools.sh`）
3. 更新 `cleanup.sh` 以移除它
4. 更新 README.md 文檔

### 同步配置
```bash
# iTerm2：自動（無需動作）

# SuperClaude：手動
cp ~/.claude/settings.json config/claude/

# 提交並推送
git add config/
git commit -m "更新配置"
git push
```
