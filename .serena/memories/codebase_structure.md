# 程式碼結構

> 最後校對：2026-09-05

## 目錄配置

```
my-mac-dev-setup/
├── MIGRATION_PLAN.md            # 換機主計劃書（遷移前必讀）
├── SETUP_PROMPT.md              # AI 執行入口（主要路徑）
├── bootstrap.sh                 # 最小化安裝：Homebrew → Claude Code → mise/Node → git
├── setup.sh                     # 傳統手動路徑（備援，依序呼叫 scripts/*.sh）
├── Brewfile                     # 新機套件目標清單（唯一事實來源）
├── Brewfile.old-machine         # 舊機快照，僅供參考，不要拿來安裝
├── scripts/
│   ├── brew.sh                 # Homebrew 安裝 + brew bundle
│   ├── node.sh                 # mise 全域設定還原 + mise install（不是 nvm）
│   ├── zsh.sh                  # OMZ + p10k 主題 + zsh-autosuggestions/
│   │                           #   zsh-syntax-highlighting（git clone 進
│   │                           #   custom/plugins，不是 brew formula）
│   │                           #   不修改 .zshrc 內容
│   ├── restore-dotfiles.sh     # 還原 .zshrc/.zprofile/.gitconfig/.p10k.zsh
│   ├── symlink-zsh.sh          # clone + symlink zsh-scripts repo
│   ├── iterm2-config.sh        # iTerm2 偏好設定同步
│   ├── macos-defaults.sh       # Dock/Finder/鍵盤/截圖 系統偏好設定
│   └── cleanup.sh              # 清理腳本（測試用）
├── git/
│   ├── setup-git.sh            # 互動式 Git 配置管理器
│   ├── .gitconfig.personal
│   └── .gitconfig.work
├── config/
│   ├── .p10k.zsh                # Powerlevel10k 預先配置
│   ├── shell/
│   │   ├── .zshrc               # 新機乾淨版（單一事實來源）
│   │   ├── .zshrc.old-machine   # 舊機原樣，僅供對照
│   │   ├── .zshrc.local.example # 秘密範本（只有 key 名稱）
│   │   ├── .zprofile
│   │   ├── .gitconfig
│   │   └── .gitignore_global
│   ├── vscode/
│   │   ├── settings.json
│   │   ├── extensions.txt
│   │   └── snippets/
│   ├── mise/config.toml         # 全域版本設定（node/uv）
│   ├── iterm2/com.googlecode.iterm2.plist
│   └── claude/settings.json     # SuperClaude 個人設定備份
└── .gitignore
```

## 腳本執行流程

### AI 路徑（`SETUP_PROMPT.md`，主線）
1. `bash scripts/zsh.sh` — Zsh/OMZ/p10k/plugins
2. `brew bundle --file=Brewfile` + `brew bundle check`
3. `bash scripts/restore-dotfiles.sh` + 建立 `~/.zshrc.local`
4. clone zsh-scripts + `bash scripts/symlink-zsh.sh`
5. `bash scripts/iterm2-config.sh`
6. 驗證
7. `bash scripts/macos-defaults.sh`（需先跟使用者確認）

### 傳統路徑（`./setup.sh`，備援）
`brew.sh` → `node.sh` → `zsh.sh` → `restore-dotfiles.sh` → `symlink-zsh.sh`
→ `iterm2-config.sh` → `macos-defaults.sh`

### 個別腳本執行
```bash
./scripts/zsh.sh              # 只裝 Zsh 環境
./scripts/brew.sh             # Brewfile（CLI + GUI apps）
```

## 職責邊界（避免兩邊各自維護一份邏輯）

- **`.zshrc` 的內容**（ZSH_THEME/plugins=()/mise 初始化等）只由
  `config/shell/.zshrc` + `restore-dotfiles.sh` 決定。`zsh.sh` 只負責把
  OMZ/主題/plugin 的軟體本身裝好，不修改 `.zshrc` 內容——避免兩邊互改。
- **套件清單**只由 `Brewfile` 決定。任何腳本都不應該有獨立的
  `brew install <個別套件>`。
- **mise 全域版本設定**只由 `config/mise/config.toml` 決定，`node.sh`
  負責把它複製到 `~/.config/mise/config.toml`（一律覆寫，只在第一次備份）。

## 配置同步策略

### iTerm2
- `defaults write` 指向 `config/iterm2/`，雙向同步

### zsh-scripts（獨立 repo）
- 位置：`~/Developer/Personal/zsh-scripts`
- Repo：`git@github.com:u88803494/zsh-scripts.git`
- `symlink-zsh.sh` 建立**兩個** symlink：整包 repo + `custom.plugin.zsh`
  直接連到 `$ZSH_CUSTOM/` 根目錄（OMZ 只自動載入根目錄下的 `*.plugin.zsh`，
  漏掉第二個 symlink 會讓自訂 alias 完全不生效且沒有錯誤訊息）

## 外部相依

- `zsh-scripts` — 自訂 aliases/functions，獨立 repo，AI 執行時需要先 clone
