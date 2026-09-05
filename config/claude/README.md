# SuperClaude 個人配置

只備份個人修改的配置，官方框架透過 SuperClaude CLI 管理。

## 📁 配置文件

### settings.json
你的個人 SuperClaude 設定，包含：

**權限配置**：
- `allow`: 允許自動執行的工具
- `deny`: 明確拒絕的工具
- `ask`: 需要詢問的工具

**工作目錄**：
- 個人專案路徑：`/Users/henrylee/personal/**`
- 工作專案路徑：`/Users/henrylee/work/**`

**MCP 工具權限**：
- Serena 工具權限
- Chrome DevTools 權限
- 其他 MCP 整合

**WebFetch 網域**：
- 允許存取的網站清單
- 常用文檔網站

## 🔄 SuperClaude 架構

### 官方框架（不備份）
由 SuperClaude CLI 管理：
- `MODE_*.md` - 行為模式（7 個）
- `agents/` - 專業代理（16 個）
- `commands/` - 斜線命令（25 個）
- `MCP_*.md` - MCP 整合文檔

這些透過 `SuperClaude update` 更新。

### 個人配置（需備份）
手動管理，存放在此：
- `settings.json` - 你的個人設定 ✅
- 未來可能加入其他個人配置

## 🚀 更新流程

### 更新 SuperClaude Framework
```bash
# 升級 SuperClaude CLI
pipx upgrade SuperClaude

# 互動式更新框架組件和 MCP servers
SuperClaude install
```

### 恢復個人設定
```bash
# 手動恢復個人設定
cp ~/Developer/Personal/my-mac-dev-setup/config/claude/settings.json ~/.claude/settings.json
```

### 備份當前設定
```bash
# 將當前設定備份到 repo
cp ~/.claude/settings.json ~/Developer/Personal/my-mac-dev-setup/config/claude/
```

## 💡 最佳實踐

1. **定期備份**：修改 settings.json 後記得備份
   ```bash
   cp ~/.claude/settings.json ~/Developer/Personal/my-mac-dev-setup/config/claude/
   git add config/claude/settings.json
   git commit -m "Update Claude settings"
   ```

2. **更新框架**：定期運行 SuperClaude 更新
   ```bash
   pipx upgrade SuperClaude && SuperClaude install
   ```

3. **版本追蹤**：透過 git 追蹤 settings.json 的變更

## 🆕 新機器設定

```bash
# 1. Clone repo
git clone https://github.com/u88803494/my-mac-dev-setup.git ~/Developer/Personal/my-mac-dev-setup

# 2. 安裝 SuperClaude
pipx install SuperClaude
SuperClaude install  # 互動式選擇組件和 MCP servers

# 3. 恢復個人設定
cp ~/Developer/Personal/my-mac-dev-setup/config/claude/settings.json ~/.claude/settings.json

# 完成！
```

## 📝 注意事項

- **不要備份**：
  - `history.jsonl`（使用歷史）
  - `todos/`（待辦事項）
  - `debug/`（偵錯資訊）
  - 這些是運行時產生的檔案

- **需要備份**：
  - `settings.json`（個人權限和設定）
  - 未來的其他個人配置
