# 程式碼結構

## 目錄配置

```
mac-dev-setup/
├── setup.sh                    # 主要安裝編排器
├── scripts/
│   ├── brew.sh                # 安裝 Homebrew + pnpm
│   ├── node.sh                # 安裝 nvm + Node.js LTS
│   ├── zsh.sh                 # 安裝 Zsh + OMZ + Powerlevel10k + 插件
│   ├── symlink-zsh.sh         # 連結到 zsh-scripts repo
│   ├── dev-tools.sh           # 安裝 git, gh, git-delta, eza, zoxide
│   ├── apps.sh                # 安裝 GUI 應用（iTerm2, VS Code, Claude Code）
│   ├── iterm2-config.sh       # 配置 iTerm2 偏好設定同步
│   └── cleanup.sh             # 清理腳本（用於測試）
├── git/
│   ├── setup-git.sh           # 互動式 Git 配置管理器
│   ├── .gitconfig.personal    # 個人 Git 配置範本
│   └── .gitconfig.work        # 工作 Git 配置範本
├── config/
│   ├── .p10k.zsh             # Powerlevel10k 預先配置的主題
│   ├── iterm2/               # iTerm2 配置同步
│   │   ├── README.md
│   │   └── com.googlecode.iterm2.plist
│   └── claude/               # SuperClaude 個人設定備份
│       ├── README.md
│       └── settings.json
├── .serena/                   # Serena MCP 專案配置（此目錄）
├── README.md                  # 完整文檔
└── .gitignore
```

## 腳本執行流程

### 主要安裝（`./setup.sh`）
依序執行腳本：
1. `brew.sh` - 套件管理器基礎
2. `node.sh` - Node.js 環境
3. `zsh.sh` - Shell 環境
4. `symlink-zsh.sh` - 自訂 aliases/functions
5. `dev-tools.sh` - 開發工具
6. `apps.sh` - GUI 應用程式
7. `iterm2-config.sh` - iTerm2 同步設定

### 個別腳本執行
`scripts/` 中的每個腳本都可以獨立執行：
```bash
./scripts/zsh.sh        # 只安裝 Zsh 環境
./scripts/apps.sh       # 只安裝 GUI 應用
```

## 配置同步策略

### iTerm2
- 使用 macOS `defaults write` 設定自訂偏好設定資料夾
- 自動同步到 `config/iterm2/com.googlecode.iterm2.plist`
- 雙向同步 - iTerm2 中的變更會自動儲存到 repo

### SuperClaude
- **框架組件**：透過 `SuperClaude install` 管理（不在 repo 中）
- **個人設定**：`config/claude/settings.json`（在 repo 中備份）
- 手動恢復：`cp config/claude/settings.json ~/.claude/settings.json`

### Zsh 配置
- 連結到獨立的 `zsh-scripts` repo（不包含在此處）
- 自訂 aliases 和 functions 在該 repo 中

## 組件間的相依性

### 強相依
- `dev-tools.sh` 安裝 shell 配置依賴的工具：
  - `eza` - `t()` 函式需要
  - `zoxide` - `j` alias 需要
  - `git-delta` - `.gitconfig` 中配置

### 弱相依
- `symlink-zsh.sh` 需要 `zsh-scripts` repo 存在
- `iterm2-config.sh` 需要 iTerm2 已安裝（來自 `apps.sh`）

## 外部相依

### 獨立的 Repository
- `zsh-scripts` - 自訂 Zsh aliases 和 functions
  - 位置：`~/personal/zsh-scripts`
  - Repo：`https://github.com/u88803494/zsh-scripts.git`
  - 透過 symlink 連結到 `~/.oh-my-zsh/custom/plugins/`
