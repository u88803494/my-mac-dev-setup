# Mac Development Environment Setup

> ⚠️ **未經完整測試** - 此腳本尚未在全新系統上測試，請謹慎使用。建議先在測試環境或虛擬機中驗證。

一鍵安裝腳本，快速配置新 macOS 機器的開發環境。

## 🎯 用途

當你換新公司、換新電腦，或重裝系統時，這個 repo 可以幫你在 **10 分鐘內**完成所有開發環境配置。

## 📦 安裝內容

### 核心環境（自動安裝）

**套件管理 & Node.js**:
- **Homebrew** - macOS 套件管理器
- **pnpm** - 快速、高效的 npm 替代方案
- **nvm** - Node.js 版本管理器
- **Node.js LTS** - 最新的 LTS 版本（設為 default）

**Shell 環境**:
- **Zsh + Oh My Zsh** - 強大的 Shell 和框架
- **Powerlevel10k** - 美觀且高效的 Zsh 主題
- **MesloLGS Nerd Font** - Powerlevel10k 推薦字型
- **Zsh Plugins**:
  - `zsh-completions` - 額外的補全功能
  - `zsh-pnpm-completions` - pnpm 指令補全
  - `zsh-autosuggestions` - 指令自動建議
  - `zsh-syntax-highlighting` - 語法高亮

**開發工具**:
- **git** - 版本控制（Homebrew 版本，比內建新）
- **gh** - GitHub CLI，管理 PR 和 Issue
- **git-delta** - 彩色 diff viewer（.gitconfig 已配置）
- **eza** - 現代化 ls 替代品（`t()` 函式依賴）
- **zoxide** - 智能 cd 工具（`j` alias 依賴）

**GUI 應用**:
- **iTerm2** - 終端機模擬器（自動配置同步）
- **Visual Studio Code** - 程式碼編輯器
- **Claude Code** - Claude AI CLI

### 可選組件（手動安裝）

**SuperClaude Framework** - AI 增強開發框架
```bash
# 安裝 SuperClaude（會包含 MCP servers）
pipx upgrade SuperClaude && SuperClaude install
```

**功能**：
- 7 個行為模式、25 個斜線命令、15 個專業代理
- 整合 MCP servers：Sequential, Context7, Magic, Serena, Tavily, Chrome DevTools
- 需要的 API keys 會在安裝時提示

**Python 工具** - 學習 Python 時需要
```bash
# 在 scripts/dev-tools.sh 中取消註解
brew install pipx uv
```

## 🚀 快速開始

### 首次使用

```bash
# 1. Clone 此 repo
git clone https://github.com/u88803494/my-mac-dev-setup.git ~/personal/mac-dev-setup

# 2. 進入目錄
cd ~/personal/mac-dev-setup

# 3. 執行安裝腳本
./setup.sh

# 4. 配置 Git（選擇個人或工作配置）
./git/setup-git.sh

# 5. （可選）安裝 SuperClaude Framework + MCP Servers
pipx upgrade SuperClaude && SuperClaude install

# 6. 重啟終端
```

就這樣！完成 🎉

## 📁 目錄結構

```
mac-dev-setup/
├── setup.sh                    # 主安裝腳本（一鍵執行）
├── scripts/
│   ├── brew.sh                # 安裝 Homebrew + pnpm
│   ├── node.sh                # 安裝 nvm + Node.js LTS
│   ├── zsh.sh                 # 安裝 Zsh + OMZ + Powerlevel10k + Plugins
│   ├── symlink-zsh.sh         # 連結 zsh-scripts repo
│   ├── dev-tools.sh           # 安裝開發工具 (git, eza, zoxide)
│   ├── apps.sh                # 安裝 GUI 應用
│   ├── iterm2-config.sh       # 配置 iTerm2 同步
│   └── cleanup.sh             # 清理腳本（測試用）
├── git/
│   ├── setup-git.sh           # Git 配置管理（互動式）
│   ├── .gitconfig.personal    # 個人配置範本
│   └── .gitconfig.work        # 工作配置範本
├── config/
│   ├── .p10k.zsh             # Powerlevel10k 配置（預先設定好）
│   ├── iterm2/               # iTerm2 配置同步目錄
│   │   ├── README.md
│   │   └── com.googlecode.iterm2.plist
│   └── claude/               # SuperClaude 個人配置
│       ├── README.md
│       └── settings.json
└── README.md
```

## 🔧 模組化使用

如果只需要安裝特定部分，可以單獨執行子腳本：

```bash
# 核心環境
./scripts/brew.sh          # Homebrew + pnpm
./scripts/node.sh          # nvm + Node.js
./scripts/zsh.sh           # Zsh 環境

# 開發工具
./scripts/dev-tools.sh     # Git 工具鏈 + 現代化 CLI
./scripts/apps.sh          # GUI 應用

# 配置
./scripts/iterm2-config.sh  # iTerm2 同步
./git/setup-git.sh          # Git 配置
```

## 🔄 配置同步

### iTerm2 配置

執行安裝後，iTerm2 會自動同步配置到 `config/iterm2/` 目錄：
- 新機器會自動載入配置
- 所有修改會自動保存到此目錄
- 可透過 git 追蹤配置變更

詳見：[config/iterm2/README.md](config/iterm2/README.md)

### SuperClaude 配置

個人 `settings.json` 備份在 `config/claude/`：
- 官方框架透過 SuperClaude CLI 管理
- 個人設定透過腳本恢復
- 運行時檔案不需要備份

詳見：[config/claude/README.md](config/claude/README.md)

## 🤖 SuperClaude Framework

### 安裝與升級

```bash
# 安裝/升級 SuperClaude
pipx install SuperClaude
pipx upgrade SuperClaude

# 互動式安裝組件和 MCP servers
SuperClaude install
```

**當前版本**: 4.1.6

### 功能

**行為模式** (7 個):
- Brainstorming, Business Panel, Deep Research
- Introspection, Orchestration, Task Management, Token Efficiency

**專業代理** (15 個):
- Backend/Frontend Architect, Python Expert, Security Engineer
- Quality Engineer, Performance Engineer, 等等

**斜線命令** (25 個):
- `/sc:implement`, `/sc:analyze`, `/sc:test`, 等等

**整合 MCP Servers**:
- **Sequential Thinking** - 多步驟問題解決
- **Context7** - 官方庫文檔查詢
- **Magic** - UI 組件生成（需要 API key）
- **Serena** - 語義代碼分析
- **Tavily** - 網頁搜尋（需要 API key）
- **Chrome DevTools** - 瀏覽器調試

### API Keys 配置

某些 MCP servers 需要 API keys：

**Tavily** - 網頁搜尋（免費：每月 1000 次）
```bash
# 1. 註冊：https://app.tavily.com/home
# 2. 設定環境變數
export TAVILY_API_KEY="your-api-key"
echo 'export TAVILY_API_KEY="your-api-key"' >> ~/.zshrc
```

**Magic** - UI 組件生成
```bash
# 1. 註冊：https://21st.dev
# 2. 設定環境變數
export TWENTYFIRST_API_KEY="your-api-key"
echo 'export TWENTYFIRST_API_KEY="your-api-key"' >> ~/.zshrc
```

## 📝 自定義 Aliases 和函式

安裝完成後，你會自動擁有這些增強功能：

### Shell 函式
- `t()` → `eza --tree`（顯示樹狀結構並複製到剪貼簿）
- `j <dir>` → `zoxide` 智能跳轉到常用目錄

### Aliases（來自 zsh-scripts）
- `c` → `claude` - Claude AI CLI
- `g` → `gemini` - Gemini AI CLI
- `cls` → `clear` - 清屏
- `uuid` → 生成小寫 UUID 並複製到剪貼簿

## ⚙️ Git 配置

執行 `./git/setup-git.sh` 會提供三種選擇：

1. **Personal** - 使用個人 email (u88803494@gmail.com)
2. **Work** - 輸入公司 email
3. **Manual** - 手動設定

**進階功能**：
- Git Delta pager（彩色 diff）
- 條件式 gitconfig include（工作/個人專案自動切換）
- Auto setup remote（git push 自動設定上游）

## 🔄 更新配置

### 更新 SuperClaude

```bash
pipx upgrade SuperClaude && SuperClaude install
```

### 更新 Shell 配置

如果你想更新某個配置（例如新增 alias）：

```bash
# 1. 更新 zsh-scripts repo
cd ~/personal/zsh-scripts
vim custom.plugin.zsh
git commit && git push

# 2. 重新載入
source ~/.zshrc
```

### 備份當前配置

```bash
# iTerm2 配置會自動同步，無需手動備份

# SuperClaude settings
cp ~/.claude/settings.json ~/personal/mac-dev-setup/config/claude/

# 提交變更
git add config/claude/settings.json
git commit -m "Update Claude settings"
```

## 🧹 測試與清理

### 清理已安裝內容

```bash
./scripts/cleanup.sh
```

**會移除**：
- 所有透過 setup.sh 安裝的工具
- Oh My Zsh 和插件
- nvm 和 Node.js
- 恢復原始 .zshrc
- 重置 iTerm2 配置路徑

**會保留**：
- Homebrew 本身（可能被其他應用使用）
- .zshrc 備份（時間戳命名）
- Git 倉庫和個人文件

適合用於測試安裝流程。

## 💡 提示

- **首次設置**：大約需要 5-10 分鐘
- **重複執行安全**：所有腳本都會檢查已安裝的項目，可以重複執行
- **Apple Silicon**：自動處理 Homebrew 路徑
- **字型設定**：安裝完成後，記得在 iTerm2 設定中選擇 "MesloLGS NF" 字型
- **Python 工具**：預設不安裝以節省空間（M1 128GB），需要時在 `scripts/dev-tools.sh` 中取消註解

## 🎯 設計理念

### 為什麼模組化？

- **支持部分安裝**：只裝 zsh，不裝 node 也可以
- **失敗隔離**：一個腳本失敗不影響其他
- **易於維護和理解**：每個腳本職責單一

### 核心 vs 可選工具

**核心工具**（自動安裝）：
- 基礎開發環境必需（Homebrew, Node.js, Zsh）
- 配置檔案已依賴的工具（eza, zoxide, git-delta）
- 無爭議的選擇

**可選工具**（文檔記錄）：
- 特定場景工具（SuperClaude, Tavily MCP）
- 個人偏好強的工具
- 需要額外配置的工具（API key）

### 不包含什麼？

- ❌ VS Code 擴充套件（太個人化）
- ❌ macOS 系統設置（變動頻繁）
- ❌ 依賴自動安裝的套件
- ❌ IDE 詳細配置

## 🐛 常見問題

### zsh-scripts repo 不存在

執行 `./scripts/symlink-zsh.sh` 前，請確保已經 clone zsh-scripts：

```bash
git clone https://github.com/u88803494/zsh-scripts.git ~/personal/zsh-scripts
```

### Powerlevel10k 配置向導跳出

如果你想使用預設配置，直接按 `q` 退出向導，repo 中的 `.p10k.zsh` 會自動套用。

### 需要重新配置 p10k

```bash
p10k configure
```

### iTerm2 配置沒有自動載入

確認配置路徑設定正確：

```bash
./scripts/iterm2-config.sh
# 然後重啟 iTerm2
```

### SuperClaude 版本號顯示不一致

這是正常的，metadata 可能顯示組件版本。查看實際版本：

```bash
SuperClaude --version
```

### MCP Server API Key 問題

如果 Tavily 或 Magic 無法使用，確認環境變數已設定：

```bash
# 檢查
echo $TAVILY_API_KEY
echo $TWENTYFIRST_API_KEY

# 設定（加到 ~/.zshrc）
export TAVILY_API_KEY="your-key"
export TWENTYFIRST_API_KEY="your-key"
```

## 📄 License

MIT

---

**Made with ❤️ for faster onboarding**
