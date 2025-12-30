# Claude Code 完整備份配置

備份所有 Claude Code 和 Serena 的個人設定，確保調教成果不遺失。

## 📁 配置文件結構

```
config/claude/
├── settings.json          # Claude Code 權限和工具設定
├── CLAUDE.md             # SuperClaude 個人入口設定（語言偏好、GitHub 規則）
├── settings.local.json   # 本地特定設定（可選）
├── README.md             # 本文件
└── serena/               # Serena MCP 專案配置
    ├── project.yml       # 專案設定
    └── memories/         # 專案知識庫（6 個記憶檔）
        ├── code_style_and_conventions.md
        ├── codebase_structure.md
        ├── design_decisions.md
        ├── project_overview.md
        ├── suggested_commands.md
        └── task_completion_checklist.md
```

## 🎯 備份內容說明

### settings.json
你的個人 Claude Code 設定：
- **權限配置**：allow/deny/ask 工具列表
- **工作目錄**：個人專案 (`/personal/**`) 和工作專案 (`/work/**`) 路徑
- **MCP 工具權限**：Serena、Chrome DevTools、Magic、Sequential 等
- **WebFetch 網域**：允許存取的網站清單（github.com、npmjs.com 等）
- **行為設定**：alwaysThinkingEnabled、model 選擇等

### CLAUDE.md
你的 SuperClaude 個人入口設定：
- **語言偏好**：繁體中文溝通、註解語言規則
- **GitHub 帳號規則**：個人專案用 `u88803494`，工作專案用公司帳號
- **框架組件導入**：自動導入所有 SuperClaude 行為模式和 MCP 文檔

### Serena 專案配置
Serena MCP 學習到的專案知識：
- **project.yml**：專案基本設定
- **memories/**：6 個專案記憶檔，包含程式碼風格、架構、設計決策等

## 🔄 SuperClaude 架構

### 官方框架（不備份）
由 SuperClaude CLI 管理，透過 `SuperClaude install` 更新：
- `MODE_*.md` - 7 個行為模式
- `agents/` - 16 個專業代理
- `commands/` - 25 個斜線命令
- `MCP_*.md` - MCP 整合文檔

### 個人配置（需備份）✅
手動管理，透過腳本備份：
- `settings.json` - Claude Code 個人設定
- `CLAUDE.md` - SuperClaude 入口設定
- `settings.local.json` - 本地特定設定（可選）
- `serena/` - Serena 專案知識庫

---

## 🚀 快速使用

### 一鍵備份（推薦）
```bash
cd ~/personal/mac-dev-setup
./scripts/backup-claude.sh
```

備份會自動執行：
1. ✅ 複製 `~/.claude/settings.json`
2. ✅ 複製 `~/.claude/CLAUDE.md`
3. ✅ 複製 `~/.claude/settings.local.json`（如果存在）
4. ✅ 複製 `.serena/project.yml`
5. ✅ 複製 `.serena/memories/`

### 一鍵恢復（新機器）
```bash
cd ~/personal/mac-dev-setup
./scripts/restore-claude.sh
```

恢復會自動執行：
1. ✅ 恢復所有設定到 `~/.claude/`
2. ✅ 恢復 Serena 配置到 `.serena/`

---

## 📝 手動操作

### 手動備份
```bash
# 1. 備份 settings.json
cp ~/.claude/settings.json ~/personal/mac-dev-setup/config/claude/

# 2. 備份 CLAUDE.md
cp ~/.claude/CLAUDE.md ~/personal/mac-dev-setup/config/claude/

# 3. 備份 Serena 配置
cp -r .serena/project.yml config/claude/serena/
cp -r .serena/memories/ config/claude/serena/

# 4. 提交到 Git
git add config/claude/
git commit -m "Backup Claude settings"
git push
```

### 手動恢復
```bash
# 1. 恢復 settings.json
cp ~/personal/mac-dev-setup/config/claude/settings.json ~/.claude/

# 2. 恢復 CLAUDE.md
cp ~/personal/mac-dev-setup/config/claude/CLAUDE.md ~/.claude/

# 3. 恢復 Serena 配置
cp config/claude/serena/project.yml .serena/
cp -r config/claude/serena/memories/ .serena/
```

---

## 🆕 新機器完整設定流程

### 方法一：使用備份腳本（推薦）
```bash
# 1. Clone repo
git clone https://github.com/u88803494/my-mac-dev-setup.git ~/personal/mac-dev-setup
cd ~/personal/mac-dev-setup

# 2. 執行 bootstrap（安裝基礎環境）
./bootstrap.sh

# 3. 安裝 SuperClaude
pipx install SuperClaude
SuperClaude install  # 互動式選擇組件和 MCP servers

# 4. 一鍵恢復所有設定
./scripts/restore-claude.sh

# 5. 檢查設定
claude --version
cat ~/.claude/CLAUDE.md
```

### 方法二：AI 自動化設定
```bash
# 執行 bootstrap 後，讓 Claude Code AI 完成剩下的設定
claude "Read SETUP_PROMPT.md and execute all steps"
```

---

## 💡 最佳實踐

### 1. 定期備份
修改任何設定後立即備份：
```bash
./scripts/backup-claude.sh
git add config/claude/
git commit -m "Update Claude settings: [描述你的修改]"
git push
```

### 2. 更新 SuperClaude Framework
定期更新官方框架（不影響個人設定）：
```bash
pipx upgrade SuperClaude
SuperClaude install
```

### 3. Git 版本追蹤
- ✅ 追蹤：`settings.json`、`CLAUDE.md`、`serena/`
- ❌ 不追蹤：`history.jsonl`、`todos/`、`debug/`（運行時檔案）

### 4. 安全性
- **API Keys**：放在 `~/.zshrc.local`，不要 commit
- **敏感設定**：使用 `settings.local.json`，加入 `.gitignore`

---

## 🔧 故障排除

### Q: 備份後 settings.json 權限問題
**A**: 確保檔案權限正確：
```bash
chmod 644 ~/.claude/settings.json
```

### Q: Serena memories 沒有恢復
**A**: 確認目錄結構正確：
```bash
ls -la .serena/memories/
# 應該看到 6 個 .md 檔案
```

### Q: SuperClaude 框架和個人設定衝突
**A**: 個人設定 (settings.json) 會覆蓋框架預設值，這是正常的。

### Q: 想重置到官方預設
**A**: 刪除個人設定，重新安裝：
```bash
rm ~/.claude/settings.json
SuperClaude install
```

---

## 📊 設定差異檢查

檢查本地和備份是否一致：
```bash
# 比較 settings.json
diff ~/.claude/settings.json config/claude/settings.json

# 比較 CLAUDE.md
diff ~/.claude/CLAUDE.md config/claude/CLAUDE.md

# 如果有差異，決定要備份還是恢復
./scripts/backup-claude.sh    # 備份目前的設定
./scripts/restore-claude.sh   # 恢復備份的設定
```

---

## 🎓 進階使用

### 自動化定期備份
設定 cron job 每週自動備份：
```bash
# 編輯 crontab
crontab -e

# 加入（每週日晚上 11 點備份）
0 23 * * 0 cd ~/personal/mac-dev-setup && ./scripts/backup-claude.sh && git add -A && git commit -m "Auto backup Claude settings" && git push
```

### 多機器同步
使用 Git 同步多台機器的設定：
```bash
# 機器 A：修改後推送
./scripts/backup-claude.sh
git add -A && git commit -m "Update settings" && git push

# 機器 B：拉取後恢復
git pull
./scripts/restore-claude.sh
```

---

## 📄 License

MIT
