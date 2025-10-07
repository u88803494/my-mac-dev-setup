# Mac Development Environment Setup

> ⚠️ **未經完整測試** - 此腳本尚未在全新系統上測試，請謹慎使用。建議先在測試環境或虛擬機中驗證。

一鍵安裝腳本，快速配置新 macOS 機器的開發環境。

## 🎯 用途

當你換新公司、換新電腦，或重裝系統時，這個 repo 可以幫你在 **10 分鐘內**完成所有開發環境配置。

## 📦 安裝內容

- **Homebrew** - macOS 套件管理器
- **pnpm** - 快速、高效的 npm 替代方案
- **nvm** - Node.js 版本管理器
- **Node.js LTS** - 最新的 LTS 版本（設為 default）
- **Zsh + Oh My Zsh** - 強大的 Shell 和框架
- **Powerlevel10k** - 美觀且高效的 Zsh 主題
- **MesloLGS Nerd Font** - Powerlevel10k 推薦字型
- **Zsh Plugins**:
  - `zsh-completions` - 額外的補全功能
  - `zsh-pnpm-completions` - pnpm 指令補全
  - `zsh-autosuggestions` - 指令自動建議
  - `zsh-syntax-highlighting` - 語法高亮
- **Custom Aliases** - 從 [zsh-scripts](https://github.com/u88803494/zsh-scripts) 載入

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

# 5. 重啟終端
```

就這樣！完成 🎉

## 📁 目錄結構

```
mac-dev-setup/
├── setup.sh              # 主安裝腳本（一鍵執行）
├── scripts/
│   ├── brew.sh          # 安裝 Homebrew + pnpm
│   ├── node.sh          # 安裝 nvm + Node.js LTS
│   ├── zsh.sh           # 安裝 Zsh + OMZ + Powerlevel10k + Plugins
│   └── symlink-zsh.sh   # 連結 zsh-scripts repo
├── git/
│   ├── setup-git.sh          # Git 配置管理（互動式）
│   ├── .gitconfig.personal   # 個人配置範本
│   └── .gitconfig.work       # 工作配置範本
├── config/
│   └── .p10k.zsh        # Powerlevel10k 配置（預先設定好）
└── README.md
```

## 🔧 模組化使用

如果只需要安裝特定部分，可以單獨執行子腳本：

```bash
# 只安裝 Homebrew + pnpm
./scripts/brew.sh

# 只安裝 nvm + Node.js
./scripts/node.sh

# 只安裝 Zsh 環境
./scripts/zsh.sh

# 只設定 zsh-scripts 連結
./scripts/symlink-zsh.sh

# 配置 Git
./git/setup-git.sh
```

## 📝 自定義 Aliases

安裝完成後，你會自動擁有這些 aliases（來自 [zsh-scripts](https://github.com/u88803494/zsh-scripts)）：

- `c` → `claude` - Claude AI CLI
- `g` → `gemini` - Gemini AI CLI
- `cls` → `clear` - 清屏
- `uuid` → 生成小寫 UUID 並複製到剪貼簿

## ⚙️ Git 配置

執行 `./git/setup-git.sh` 會提供三種選擇：

1. **Personal** - 使用個人 email (u88803494@gmail.com)
2. **Work** - 輸入公司 email
3. **Manual** - 手動設定

## 🔄 更新配置

如果你想更新某個配置（例如新增 alias）：

```bash
# 1. 更新 zsh-scripts repo
cd ~/personal/zsh-scripts
vim custom.plugin.zsh
git commit && git push

# 2. 重新載入
source ~/.zshrc
```

## 💡 提示

- **首次設置**：大約需要 5-10 分鐘
- **重複執行安全**：所有腳本都會檢查已安裝的項目，可以重複執行
- **Apple Silicon**：自動處理 Homebrew 路徑
- **字型設定**：安裝完成後，記得在終端機設定中選擇 "MesloLGS NF" 字型

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

## 📄 License

MIT

---

**Made with ❤️ for faster onboarding**
