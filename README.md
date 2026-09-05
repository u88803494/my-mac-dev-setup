# Mac Development Environment Setup

🚀 **AI-Powered Setup** - 使用 Claude Code AI 自動化配置你的開發環境

---

## 🧳 要換新電腦？

**先讀 [MIGRATION_PLAN.md](./MIGRATION_PLAN.md)。**

這份 README 講的是「新機怎麼裝」，但換機的風險幾乎都在**舊機這一端**：
沒推上去的 code、沒備份的秘密、沒反啟用的授權。遷移計劃涵蓋：

- §1 遷移前檢查（未推送的 repo、設定匯出、秘密收攏、軟體反啟用）
- §2 舊機技術債清單（哪些東西**刻意不要**帶到新機）
- §3 新機安裝順序
- §5 驗收清單

---

## 🎯 快速開始（新方式）

在全新的 Mac 上，只需 **一條命令** + **AI 接手**：

```bash
# 1. 執行 Bootstrap（3 分鐘）
curl -fsSL https://raw.githubusercontent.com/u88803494/my-mac-dev-setup/main/bootstrap.sh | bash

# 2. Clone 此 repo
git clone https://github.com/u88803494/my-mac-dev-setup.git ~/Developer/Personal/my-mac-dev-setup
cd ~/Developer/Personal/my-mac-dev-setup

# 3. 讓 Claude Code AI 完成剩下的設定（5 分鐘）
claude "Read SETUP_PROMPT.md and execute all steps, asking for confirmation before major changes"

# 4. 重啟終端
# 完成！🎉
```

---

## 💡 工作原理

### 階段 1：Bootstrap（傳統腳本）
`bootstrap.sh` 安裝最小化基礎環境：
- ✅ Homebrew（套件管理器）
- ✅ mise（版本管理器，取代 nvm/pyenv/rbenv）
- ✅ Node.js LTS（透過 mise）
- ✅ pnpm（透過 mise）
- ✅ Claude Code（AI 助手）
- ✅ git（clone repos）

### 階段 2：AI 配置（智能自動化）
Claude Code 讀取 `SETUP_PROMPT.md` 並執行：
- 安裝 Zsh + Oh My Zsh + Powerlevel10k
- 安裝開發工具（eza, zoxide, gh, git-delta）
- 安裝 GUI 應用（iTerm2, VS Code）
- 配置 .zshrc 和 shell 環境
- 設定 zsh-scripts（自定義 aliases/functions）
- 建立 .zshrc.local（秘密管理）
- 驗證所有工具正常運作

### 優勢
- **智能錯誤處理**：AI 能理解錯誤並自動修正
- **互動式確認**：每個重要步驟都會先問你
- **靈活調整**：可以用自然語言調整配置
- **有備用方案**：AI 失敗還能用傳統腳本

---

## 📦 安裝內容

### 核心工具（Bootstrap 自動安裝）
- **Homebrew** - macOS 套件管理器
- **mise** - 統一版本管理器（Node.js, Python, Ruby...）
- **Node.js LTS** - 最新 LTS 版本（透過 mise）
- **pnpm** - 高效的 npm 替代方案
- **Claude Code** - AI 編程助手
- **git** - 版本控制

### Shell 環境（AI 自動配置）
- **Zsh + Oh My Zsh** - 強大的 Shell 框架
- **Powerlevel10k** - 美觀高效的主題（預配置）
- **MesloLGS Nerd Font** - 推薦字型
- **Zsh Plugins**:
  - zsh-completions
  - zsh-pnpm-completions
  - zsh-autosuggestions
  - zsh-syntax-highlighting

### 開發工具（AI 自動配置）
- **eza** - 現代化 ls 替代（t() 函式需要）
- **zoxide** - 智能目錄跳轉（j alias 需要）
- **gh** - GitHub CLI
- **git-delta** - 彩色 diff viewer

### GUI 應用（AI 自動配置）
- **iTerm2** - 終端模擬器（自動同步配置）
- **Visual Studio Code** - 程式碼編輯器

### 自定義腳本（AI 自動配置）
- **zsh-scripts** - 個人 aliases 和 functions
  - Repository: https://github.com/u88803494/zsh-scripts
  - 自動 clone 並 symlink 到 Oh My Zsh

---

## 🔧 傳統方式（不使用 AI）

如果你偏好手動控制或 AI 不可用：

```bash
# 1. 執行 bootstrap
curl -fsSL https://raw.githubusercontent.com/u88803494/my-mac-dev-setup/main/bootstrap.sh | bash

# 2. Clone repo
git clone https://github.com/u88803494/my-mac-dev-setup.git ~/Developer/Personal/my-mac-dev-setup
cd ~/Developer/Personal/my-mac-dev-setup

# 3. 一鍵執行全部
./setup.sh

# 或執行個別腳本
./scripts/brew.sh            # Homebrew + Brewfile（CLI + GUI apps）
./scripts/node.sh            # mise + Node.js
./scripts/zsh.sh             # Shell 環境
./scripts/restore-dotfiles.sh # .zshrc / .gitconfig / .p10k.zsh
./scripts/symlink-zsh.sh     # zsh-scripts
./scripts/iterm2-config.sh   # iTerm2 配置
./scripts/macos-defaults.sh  # macOS 系統偏好設定

# 4. 配置 Git
./git/setup-git.sh

# 5. 重啟終端
```

---

## 📁 目錄結構

```
my-mac-dev-setup/
├── MIGRATION_PLAN.md            # 🆕 新電腦遷移計劃（遷移前必讀）
├── Brewfile                     # 🆕 新機目標套件清單（curated）
├── Brewfile.old-machine         # 🆕 舊機原樣快照（參考用）
├── bootstrap.sh                 # 最小化安裝（Homebrew → mise → Node → Claude Code）
├── setup.sh                     # 一鍵執行全部腳本
├── SETUP_PROMPT.md              # AI 配置指令（Claude Code 讀取）
├── README.md
├── config/
│   ├── .p10k.zsh                # Powerlevel10k 預配置
│   ├── shell/                   # 🆕 dotfiles
│   │   ├── .zshrc               #   新機乾淨版
│   │   ├── .zshrc.old-machine   #   舊機原樣（含已淘汰的 PATH）
│   │   ├── .zshrc.local.example #   秘密範本（只有 key 名稱）
│   │   ├── .zprofile
│   │   ├── .gitconfig
│   │   └── .gitignore_global
│   ├── vscode/                  # 🆕 VS Code
│   │   ├── settings.json
│   │   ├── extensions.txt
│   │   └── snippets/
│   ├── mise/config.toml         # 🆕 全域版本設定
│   ├── iterm2/
│   │   └── com.googlecode.iterm2.plist
│   └── claude/                  # SuperClaude 個人設定
├── scripts/
│   ├── brew.sh                  # Homebrew + brew bundle
│   ├── node.sh                  # mise（已不再使用 nvm）
│   ├── zsh.sh
│   ├── restore-dotfiles.sh      # 🆕
│   ├── symlink-zsh.sh
│   ├── iterm2-config.sh
│   ├── macos-defaults.sh        # 🆕
│   └── cleanup.sh
└── git/
    ├── setup-git.sh
    ├── .gitconfig.personal
    └── .gitconfig.work
```

---

## 🎯 mise vs nvm

新版使用 **mise** 取代 nvm：

### 為什麼用 mise？

| nvm | mise |
|-----|------|
| 只管理 Node.js | 管理所有語言（Node, Python, Ruby, Go...） |
| Shell script（慢） | Rust（超快） |
| 需要手動 `nvm use` | **自動切換版本** |
| 每個語言要裝不同工具 | **一個工具全搞定** |

### 使用方式

```bash
# 全域設定
mise use -g node@22
mise use -g python@3.12

# 專案級設定（自動切換）
cd ~/Developer/Work/project-a
mise use node@18        # 建立 .mise.toml
node --version          # v18.x

cd ~/Developer/Personal/project-b
mise use node@22
node --version          # v22.x（自動切換！）
```

---

## 🔐 秘密管理

### .zshrc.local（推薦方式）

從 `config/shell/.zshrc.local.example` 複製後填值（範本只含 key 名稱，不含實際值）：

```bash
cp config/shell/.zshrc.local.example ~/.zshrc.local
chmod 600 ~/.zshrc.local
```

```bash
# ~/.zshrc.local（不會 commit 到 git）
export TAVILY_API_KEY="your-key"
export MORPH_API_KEY="your-key"
export SUPABASE_ACCESS_TOKEN="your-token"
```

`.zshrc` 會自動載入：
```bash
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
```

**永遠不要把秘密 commit 到 git！**

---

## 🔄 配置同步

### iTerm2
- 配置自動同步到 `config/iterm2/`
- 新機器自動載入
- 修改會自動保存

### zsh-scripts
- 獨立 repository 管理
- 透過 symlink 連結到 Oh My Zsh
- 更新：`cd ~/Developer/Personal/zsh-scripts && git pull`

---

## 📝 自定義功能

安裝完成後你會有這些增強：

### Shell Functions
- `t()` → 顯示目錄樹狀結構並複製到剪貼簿（使用 eza）
- `j <dir>` → 智能跳轉到常用目錄（使用 zoxide）

### Aliases（來自 zsh-scripts）
- `c` → `claude` - Claude AI CLI
- `g` → `gemini` - Gemini AI CLI
- `cop` → `copilot` - GitHub Copilot CLI
- `cls` → `clear` - 清屏
- `uuid` → 生成小寫 UUID 並複製

---

## ⚙️ Git 配置

```bash
./git/setup-git.sh
```

提供三種選擇：
1. **Personal** - 個人 email (u88803494@gmail.com)
2. **Work** - 公司 email
3. **Manual** - 手動設定

**功能**：
- Git Delta pager（彩色 diff）
- 條件式 gitconfig（工作/個人專案自動切換）
- Auto setup remote

---

## 🎨 可選組件

### SuperClaude Framework

AI 增強開發框架（可選）：

```bash
# 安裝
pipx install SuperClaude
SuperClaude install
```

**功能**：
- 7 個行為模式、25 個斜線命令、15 個專業代理
- MCP servers：Sequential, Context7, Magic, Serena, Tavily
- 需要 API keys（安裝時會提示）

### Python 工具

需要 Python 開發時：

```bash
mise use -g python@3.12
brew install pipx uv
```

---

## 🧹 測試與清理

### 清理已安裝內容

```bash
./scripts/cleanup.sh
```

會移除所有安裝的工具，適合測試。

---

## 💡 設計理念

### AI-First Approach
- **Bootstrap 最小化**：只裝 AI 需要的基礎
- **AI 智能化**：讓 AI 處理複雜配置
- **備用方案**：傳統腳本作為後備

### 模組化設計
- 每個腳本單一職責
- 失敗隔離
- 可重複執行

### 核心 vs 可選
- **核心**：自動安裝，無爭議的工具
- **可選**：文檔說明，需要時手動安裝

---

## 🐛 常見問題

### Q: 為什麼不用 Homebrew 直接裝 Node？
**A**: mise 可以管理多版本，專案自動切換，比 Homebrew 靈活。

### Q: zsh-scripts repo 不存在怎麼辦？
**A**: AI 會自動 clone。如果失敗，手動執行：
```bash
git clone https://github.com/u88803494/zsh-scripts.git ~/Developer/Personal/zsh-scripts
```

### Q: 想重新配置 Powerlevel10k
**A**: 執行 `p10k configure`

### Q: API Keys 放哪裡？
**A**: 編輯 `~/.zshrc.local`（AI 會自動建立）

### Q: AI 設定失敗了
**A**: 使用備用的傳統腳本：`./scripts/*.sh`

---

## 🆚 新舊方式對比

| 舊方式 | 新方式（AI-Powered） |
|--------|---------------------|
| 7 個腳本要跑 | 1 個 bootstrap + AI |
| nvm 管理 Node | mise 管理所有語言 |
| 10 分鐘手動執行 | 8 分鐘自動化 |
| 出錯要自己 debug | AI 自動修正 |
| 配置固定 | 自然語言調整 |

---

## 📄 License

MIT

---

**Made with ❤️ and 🤖 AI**
