# 常用命令建議

> 最後校對：2026-09-05

## 安裝命令

### AI 路徑（主線）
```bash
claude "Read MIGRATION_PLAN.md and SETUP_PROMPT.md, then execute the setup"
```

### 傳統手動路徑（備援）
```bash
./setup.sh
```

### 模組化安裝
```bash
./scripts/brew.sh              # Homebrew + brew bundle（CLI + GUI apps）
./scripts/node.sh              # mise 全域設定 + mise install（不是 nvm）
./scripts/zsh.sh                # Zsh + OMZ + p10k + plugins（不碰 .zshrc 內容）
./scripts/restore-dotfiles.sh   # 還原 .zshrc / .gitconfig / .p10k.zsh
./scripts/symlink-zsh.sh        # zsh-scripts symlink
./scripts/iterm2-config.sh      # iTerm2 同步
./scripts/macos-defaults.sh     # 系統偏好設定（執行前先跟使用者確認）
./git/setup-git.sh              # Git 配置（互動式）
```

## 套件管理

```bash
brew bundle --file=Brewfile              # 安裝
brew bundle check --file=Brewfile         # 驗證是否都裝齊
brew bundle dump --file=Brewfile.tmp --force  # 產生目前實機快照（對照用）
```

⚠️ 不要對個別套件跑 `brew install`——會跟 Brewfile 這個單一事實來源脫節，
且下次 `brew bundle cleanup` 會誤判成多餘套件而移除。

## 測試命令

```bash
./scripts/cleanup.sh   # 移除已安裝組件（測試用）
./setup.sh             # 重新安裝
```

### 驗證命令
```bash
brew --version
mise --version
node --version
pnpm --version
git --version
eza --version
zoxide --version
git config --global user.name
git config --global user.email
```

## 配置備份

### SuperClaude 設定
```bash
cp ~/.claude/settings.json ~/Developer/Personal/my-mac-dev-setup/config/claude/
cp ~/Developer/Personal/my-mac-dev-setup/config/claude/settings.json ~/.claude/
```

### Zsh 配置（zsh-scripts，獨立 repo）
```bash
cd ~/Developer/Personal/zsh-scripts
vim custom.plugin.zsh
git commit && git push
source ~/.zshrc
```

### dotfiles（config/shell/）
```bash
# 有調整 ~/.zshrc 之後，想更新回 repo：
cp ~/.zshrc ~/Developer/Personal/my-mac-dev-setup/config/shell/.zshrc
```

## Git 操作

```bash
./git/setup-git.sh   # 選擇：1) 個人 2) 工作 3) 手動
```

## 有用的 Shell 函式（zsh-scripts，安裝後可用）

```bash
t                  # 樹狀檢視並複製到剪貼簿
j <dir>            # 智能目錄跳轉
c                  # 啟動主帳號 Claude Code
cc                 # 啟動第二個 Claude 帳號（CLAUDE_CONFIG_DIR=~/.claude-alt）
claude-sync-mcp    # 同步主帳號 mcpServers 到 cc 共用設定
a                  # 開啟 Antigravity IDE
cls                # 清除畫面
uuid               # 生成 UUID（小寫，複製到剪貼簿）
```

## macOS 特定命令

```bash
uname -m            # arm64 = Apple Silicon, x86_64 = Intel
sw_vers              # macOS 版本
brew leaves           # 列出直接安裝的套件（僅 formulae，不含 cask）
```

## 疑難排解

### Powerlevel10k 配置
```bash
p10k configure   # 重新執行配置精靈（repo 的預先配置版本已自動套用）
```

### iTerm2 配置未載入
```bash
./scripts/iterm2-config.sh   # 然後重啟 iTerm2
```

### 自訂 alias（c/cc/j/t()）沒有生效
先確認兩個 symlink 都存在，再懷疑 `.zshrc`：
```bash
ls -la ~/.oh-my-zsh/custom/zsh-scripts
ls -la ~/.oh-my-zsh/custom/custom.plugin.zsh
# 都沒有就重跑
./scripts/symlink-zsh.sh
```

### mise 裝的工具（例如 uv）沒出現
`bootstrap.sh` 的 `mise use -g node@lts` 會搶先建立一份沒有 `uv` 的
`~/.config/mise/config.toml`。確認有跑過 `scripts/node.sh`（它會用
`config/mise/config.toml` 覆寫並重新 `mise install`），而不是假設
bootstrap 階段就已經處理好全部工具。

## 開發工作流程

### 進行變更
1. 編輯腳本或配置
2. `./scripts/cleanup.sh` 然後個別腳本測試
3. 若同時改了 `SETUP_PROMPT.md` 對應段落，確認兩邊沒有分岔
4. 提交變更到 git，推送到 GitHub

### 添加新套件
1. 加進 `Brewfile`（不要在腳本裡個別 `brew install`）
2. 更新 README.md「安裝內容」區段
3. 若是 Zsh 相關，確認 `config/shell/.zshrc` 的 `plugins=()` 跟
   `scripts/zsh.sh` 的安裝方式一致

### 這個 repo 的架構有重大變動時
1. 同步更新這幾份 `.serena/memories/`——它們會在新機透過 Serena MCP
   啟動時被載入，內容落後會直接誤導 AI（曾經發生過 nvm/mise 矛盾的實例）
2. 更新 `MIGRATION_PLAN.md` §6
