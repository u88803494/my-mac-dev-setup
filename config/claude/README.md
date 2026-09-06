# SuperClaude 個人配置

只備份個人修改的配置，官方框架透過 SuperClaude CLI 管理。

## 📁 配置文件

### CLAUDE.md
框架入口檔 + 你自己寫的個人規則（例如睡眠自律 hook 的說明文字）。**這份檔案本身就是需要備份的個人配置，不是官方框架的一部分**——之前這份文件漏列了它，導致 2026-09 這次換機時 `~/.claude/` 完全沒有這個檔案，個人規則差點遺失。

### settings.json
你的個人 SuperClaude 設定，包含：

**權限配置**：
- `allow`: 允許自動執行的工具
- `deny`: 明確拒絕的工具
- `ask`: 需要詢問的工具

**工作目錄**（2026-09 換機時修正過路徑，原本寫的 `/Users/henrylee/...` 是舊使用者名稱、且 `work` 目錄實際位置也對不上）：
- 工作專案路徑：`~/Developer/Work/**`

**MCP 工具權限**：
- Serena 工具權限
- Chrome DevTools 權限
- 其他 MCP 整合

**WebFetch 網域**：
- 允許存取的網站清單
- 常用文檔網站

## 🔄 SuperClaude 架構

⚠️ **2026-09 換機實測更正**：以下這段原本假設「官方框架的東西 `SuperClaude` CLI 都能重裝」，實測發現只對一半——`agents/`、`commands/` 這兩個資料夾可以，但 `~/.claude/` 根目錄下那批被 `CLAUDE.md` 用 `@FLAGS.md` 這種語法引用的核心框架檔（`FLAGS.md`／`RULES.md`／`PRINCIPLES.md`／`BUSINESS_*.md`／`MODE_*.md`／`MCP_*.md`，共 20 個）**沒有任何 `SuperClaude` 子指令會把它們裝到 `~/.claude/`**——`SuperClaude install` 只處理 commands/agents，`install-skill`/`mcp` 也都不管這批檔案。這些檔案雖然照樣打包在 pip 套件裡，但要自己手動複製出來：

```bash
# SuperClaude 版本要跟這裡標的一致（4.3.0），不同版本檔名/路徑可能改變
VENV="$HOME/Library/Application Support/pipx/venvs/superclaude/lib/python3.14/site-packages/superclaude"
cp "$VENV/core/"{BUSINESS_PANEL_EXAMPLES,BUSINESS_SYMBOLS,FLAGS,PRINCIPLES,RESEARCH_CONFIG,RULES}.md ~/.claude/
cp "$VENV/modes/"{MODE_Brainstorming,MODE_Business_Panel,MODE_DeepResearch,MODE_Introspection,MODE_Orchestration,MODE_Task_Management,MODE_Token_Efficiency}.md ~/.claude/
cp "$VENV/mcp/"{MCP_Context7,MCP_Magic,MCP_Morphllm,MCP_Playwright,MCP_Sequential,MCP_Serena,MCP_Tavily}.md ~/.claude/
```

（`python3.14` 那段路徑跟著 `pipx` 當時用的 Python 版本走，實際路徑用 `pipx list` 或 `find "$HOME/Library/Application Support/pipx/venvs/superclaude" -iname FLAGS.md` 確認。）

### 官方框架（`SuperClaude install` 可重裝，不進 git）
- `agents/`（20 個，已驗證跟套件內建版本逐位元組相同）
- `commands/sc/`（31 個，同上）

```bash
SuperClaude install --force   # 一次重裝 agents + commands/sc
```

### 個人配置（需備份，進 git）
手動管理，存放在此：
- `CLAUDE.md` - 框架入口 + 個人規則 ✅
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
cp ~/Developer/Personal/my-mac-dev-setup/config/claude/CLAUDE.md ~/.claude/CLAUDE.md
```

### 備份當前設定
```bash
# 將當前設定備份到 repo
cp ~/.claude/settings.json ~/Developer/Personal/my-mac-dev-setup/config/claude/
cp ~/.claude/CLAUDE.md ~/Developer/Personal/my-mac-dev-setup/config/claude/
```

## 💡 最佳實踐

1. **定期備份**：修改 settings.json 或 CLAUDE.md 後記得備份
   ```bash
   cp ~/.claude/settings.json ~/.claude/CLAUDE.md ~/Developer/Personal/my-mac-dev-setup/config/claude/
   git add config/claude/settings.json config/claude/CLAUDE.md
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

# 2. 安裝 SuperClaude，裝 agents + commands/sc
pipx install SuperClaude
SuperClaude install --force

# 3. 手動補上 install 不會裝的核心框架檔（見上面「SuperClaude 架構」章節的指令）

# 4. 恢復個人設定
cp ~/Developer/Personal/my-mac-dev-setup/config/claude/settings.json ~/.claude/settings.json
cp ~/Developer/Personal/my-mac-dev-setup/config/claude/CLAUDE.md ~/.claude/CLAUDE.md

# 5. 重新安裝需要的 MCP servers（不是從備份還原——mcpServers 的設定檔會內嵌 API key
#    明文，不適合進 git，所以用重新安裝取代還原）
SuperClaude mcp --servers sequential-thinking --servers context7 --servers playwright --servers serena --scope user
# magic / morphllm-fast-apply / tavily 這三個 SuperClaude mcp 指令目前有 bug
# （傳給 claude mcp add 的 -e 參數格式錯誤），要改用底層指令手動裝，見下方「已知問題」

# 完成！
```

## ⚠️ 已知問題（SuperClaude 4.3.0 實測踩過的坑）

1. **`SuperClaude mcp --servers <需要 API key 的服務>` 會失敗**：錯誤訊息是 `Invalid environment variable format`。原因是這個指令組出的底層 `claude mcp add` 呼叫，`-e` 參數格式不對。繞過方式是直接呼叫 `claude mcp add`：
   ```bash
   claude mcp add magic --transport stdio --scope user -e TWENTY_FIRST_API_KEY="$TWENTY_FIRST_API_KEY" -- npx -y @21st-dev/magic
   claude mcp add morphllm-fast-apply --transport stdio --scope user -e MORPH_API_KEY="$MORPH_API_KEY" -- npx -y @morph-llm/morph-fast-apply
   claude mcp add tavily --transport stdio --scope user -e TAVILY_API_KEY="$TAVILY_API_KEY" -- npx -y tavily-mcp@0.1.2
   ```
   （`--scope user` 一定要加，不加會預設裝成 `local` scope、綁死在當下的 cwd 專案，其他專案看不到。）

2. **`magic` 需要的環境變數名稱，SuperClaude 自己的 `mcp --list` 說明寫錯了**：它說是 `TWENTYFIRST_API_KEY`（沒有底線），但 `@21st-dev/magic` 套件實際讀的是 `TWENTY_FIRST_API_KEY`（有底線）。以 `config/shell/.zshrc.local.example` 裡的名稱為準。

3. **`morphllm-fast-apply` 連線後 `tools/list` 會報 schema 驗證錯誤**（`inputSchema.type: expected "object"`），目前判斷是套件本身的 bug，不是設定問題，先不處理。

## 📝 注意事項

- **不要備份**：
  - `history.jsonl`（使用歷史）
  - `todos/`（待辦事項）
  - `debug/`（偵錯資訊）
  - 這些是運行時產生的檔案
  - `~/.claude.json` 的 `mcpServers`（含明文 API key，見上方「新機器設定」用重裝取代還原）

- **需要備份**：
  - `CLAUDE.md`（框架入口 + 個人規則）
  - `settings.json`（個人權限和設定）
  - 未來的其他個人配置
