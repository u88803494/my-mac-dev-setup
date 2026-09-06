# 新電腦遷移計劃（Clean Install）

> 建立日期：2026-09-05
> 舊機：MacBook Air M1 (MacBookAir10,1) / 8GB / 256GB / macOS 26.6.2
> 策略：**不使用 Migration Assistant**，全新安裝 + 選擇性還原

---

## 0. 現況快照（掃描結果）

| 項目 | 現況 |
|---|---|
| 硬碟 | 228GB 中已用 182GB（92%），僅剩 18GB |
| 家目錄佔用 | Library 54G、Developer 12G、Downloads 4.8G、`.cache` 13G |
| 最大單一目錄 | `~/Library/Application Support/Claude` 11G、`com.apple.wallpaper` 8.3G |
| Shell | zsh + Oh My Zsh + Powerlevel10k（`.p10k.zsh` 95KB 已設定完成） |
| 版本管理 | **mise（現役）+ nvm（殘留，885MB／5 個 Node 版本）** 並存 |
| Node | v22.21.1（mise 管理）、pnpm 9.15.4 |
| Homebrew | 20 個 formulae、8 個 cask、2 個第三方 tap |
| 外接儲存 | HPSSD 953GB（已用 29GB，可用 693GB）→ **遷移中繼站** |
| Time Machine | 目的地 `TimeMachine`（Local，配額 300GB） |
| 備份 repo | 本 repo 已存在，但內容過時（見 §6） |

---

## 1. 遷移前必做（在舊機上，**不可略過**）

### 1.1 把所有程式碼推上 GitHub

> 掃描結果（2026-09-05），共 19 個 git repo + 9 個非 repo 目錄

**A. 有 remote，但有未提交或未推送的東西**

| Repo | 未提交 | 未推送 commit | 說明 |
|---|---|---|---|
| `Personal/my-website` | 0 | 30 | `main` 領先 1、`feat/velite-blog-phase-3` 領先 4；`feat/blog-redesign` 與 `feat/velite-blog-phase-2-backup` 是純本機分支 |
| `Personal/flourish` | 0 | 13 | `backup-before-rebase` 分支從未推送；`main` 落後 30，需先 pull |
| `Personal/market-pulse` | 6 | 5 | 改動與未推送 commit 都有 |
| `Personal/henry-atlas` | 0 | 1 | |
| `Personal/my-mac-dev-setup` | 0 | 2 | 本次的 `feat/new-mac-migration` 分支 |
| `Personal/job-hunting` | 2 | 0 | `daemon.log`（可加 gitignore）、`strategy/portfolio-decision-panel-20260904.md` |
| `Personal/zsh-scripts` | 1 | 0 | **`custom.plugin.zsh` — 最關鍵，新機 shell 靠它** |
| `Personal/dictionary` | 1 | 0 | `.nvmrc` 未追蹤（新機用 mise，可考慮改 `.mise.toml`） |

**B. 完全沒有 git remote — 不處理就會消失**

| 目錄 | 未提交 | 決策 |
|---|---|---|
| `Personal/curves_tool` | 5 | ☐ 建 private repo ☐ 打包存 HPSSD ☐ 放棄 |
| `Personal/my-dapp-guestbook` | 2 | ☐ 建 private repo ☐ 打包存 HPSSD ☐ 放棄 |
| `Personal/movie-ticket-system` | 0 | ☐ 建 private repo ☐ 打包存 HPSSD ☐ 放棄 |
| `Personal/turbo-test` | 0 | ☐ 大概可以放棄（測試用） |

**C. 根本不是 git repo 的目錄**

| 目錄 | 大小 | 決策 |
|---|---|---|
| `Work/eucare` | 1.7G | ☐ 公司專案，確認是否該留在個人機器上 |
| `Personal/interview hw` | 675M | ☐ 多半是 node_modules，清掉後再判斷 |
| `Work/arisan` | 190M | ☐ |
| `Personal/fastapi-quick-practice` | 63M | ☐ |
| `Personal/references` | 976K | ☐ |
| `Personal/research` | 416K | ☐ |
| `Personal/project-planning` | 196K | ☐ |
| `Personal/tradie-platform` | 4.0K | ☐ 空的，可刪 |
| `Work/wishmobile` | 8.0K | ☐ 空的，可刪 |

**D. 已確認乾淨（不用管）**
`ai-dictionary`、`apex`、`b2b-user-management`、`flix-finder`、`flourish-flow`、
`taipei-rental-finder`、`Work/buddhist`

**重跑這份稽核：**

```bash
find ~/Developer -maxdepth 3 -name .git -type d | sort | while read g; do
  d=$(dirname "$g")
  r=$(git -C "$d" remote | head -1)
  dirty=$(git -C "$d" status --porcelain | wc -l | tr -d ' ')
  unpushed=$(git -C "$d" log --branches --not --remotes --oneline | wc -l | tr -d ' ')
  [ -z "$r" ] && echo "❌ 無 remote: ${d#$HOME/Developer/}" && continue
  [ "$dirty" != "0" ] || [ "$unpushed" != "0" ] && \
    echo "⚠️  ${d#$HOME/Developer/}  未提交=$dirty 未推送=$unpushed"
done
```

### 1.2 匯出設定清單（跑完 commit 進本 repo）

```bash
cd ~/Developer/Personal/my-mac-dev-setup
brew bundle dump --file=Brewfile --force        # formulae + cask + tap
code --list-extensions > config/vscode/extensions.txt
cp ~/Library/Application\ Support/Code/User/settings.json config/vscode/
cp ~/Library/Application\ Support/Code/User/keybindings.json config/vscode/ 2>/dev/null
cp ~/.zshrc ~/.zprofile ~/.gitconfig ~/.gitignore_global config/shell/
cp ~/.config/mise/config.toml config/mise/
defaults export com.googlecode.iterm2 config/iterm2/com.googlecode.iterm2.plist
cp ~/.claude/settings.json ~/.claude/CLAUDE.md config/claude/   # 見 config/claude/README.md
```

⚠️ **2026-09 換機才發現這步之前一直漏掉**：`config/claude/settings.json`（完整權限清單）跟 `CLAUDE.md`（個人規則）早就該匯出，但過去從來沒人真的跑過這行，導致新機的 `~/.claude/` 只剩裸設定，詳細的權限白名單、CLAUDE.md 裡的個人規則全部沒生效。以後每次匯出都不要漏這行。

### 1.3 秘密與憑證（**不進 git**，用 1Password／密碼管理器或加密隨身碟）

- [ ] `~/.zshrc.local` — `MORPH_API_KEY`、`SUPABASE_ACCESS_TOKEN`、`TAVILY_API_KEY`、`TWENTY_FIRST_API_KEY`、`PERSONAL_DIR`、`WORK_DIR`
- [ ] `GEMINI_API_KEY`（my-website 開發需要，目前只在 Vercel／專案 `.env.local`）
- [ ] **MCP servers 清單**（不是備份 `~/.claude.json` 本身——`mcpServers` 內嵌明文 API key，不適合搬移／進 git）：
      記下 `claude mcp list` 目前有哪些 user-scope 的開發用 MCP（2026-09 當時是 `sequential-thinking`／`context7`／`magic`／`playwright`／`serena`／`morphllm-fast-apply`／`tavily`），
      新機用 `SuperClaude mcp --servers ...` 重新安裝、API key 從密碼管理器重新輸入。
      實際安裝時踩過的坑見 `config/claude/README.md`「已知問題」章節。
- [ ] `~/.ssh/id_ed25519` + `.pub`（GitHub 用）→ 新機重新產生一把新 key。
      **舊 key 何時移除見 §3 步驟 12——不要在這階段先手動去 GitHub 刪，
      要等新機驗證新 key 可用之後才刪，避免兩台機器同時 push 不了的空窗期**
- [ ] `gh` token（存在 keyring）→ 新機直接 `gh auth login` 重新登入即可，不用搬；
      舊機那把 token 建議在確認不再使用舊機後跑 `gh auth logout` 主動撤銷
- [ ] `~/.aws/`、`~/.config/rclone/`（rclone 設定含雲端 token）
- [ ] 各專案的 `.env.local`（不在 git 內）→ 逐一收集
- [ ] macOS Keychain：**不整包搬**，用密碼管理器逐項重建

### 1.4 個人檔案盤點（搬到 HPSSD）

- [ ] `~/Desktop`（35 個檔案，多為截圖 → 大部分可刪）
- [ ] `~/Documents`（護照／簽證／機票 PDF、書籤備份 HTML → **重要，務必備份**）
- [ ] `~/Pictures` 1.6G、`~/Movies` 2.7G
- [ ] `~/Downloads` 4.8G（267 個檔案 → 建議直接放棄，只挑真正要的）
- [ ] `~/EVPlayer2_download` 440M（825 個檔案 → 確認後放棄）
- [ ] pCloud（`~/.pcloud` symlink 指向 `/Volumes/HPSSD/.pcloud`）→ 確認雲端已同步完成
- [ ] Obsidian vault、Logseq（`~/.logseq` 18M）位置確認
- [ ] **HPSSD 本身是否已加密**（這裡會暫存護照/簽證掃描檔）：
      ```bash
      diskutil apfs list /Volumes/HPSSD   # 檢查 FileVault/加密狀態
      # 未加密就跑：diskutil apfs encryptVolume /Volumes/HPSSD
      ```

### 1.5 反啟用 / 登出（**遷移前做，事後很麻煩**）

- [ ] Adobe / PhotoDirector 365 / Aiarty 等付費軟體：反啟用授權
- [ ] NordVPN、VPN Proxy Master：確認裝置數上限，登出舊機
- [ ] Steam / Epic：登出（Steam 3.1G 遊戲資料不用搬，重下載）
- [ ] iCloud「尋找」→ 關閉，避免新機啟用鎖問題（Activation Lock 目前為 Enabled）
- [ ] **Apple ID → 這台 Mac 從「登入的裝置」清單移除**（不只是關掉尋找——
      設定 → 使用者 Apple ID → 往下找到裝置清單，主動撤銷這台的信任關係）
- [ ] iMessage / FaceTime 登出
- [ ] Signal：先在新機做**裝置連結**，別直接抹掉舊機
- [ ] LINE：確認已綁定 email／電話，聊天記錄先備份
- [ ] pCloud（或其他雲端硬碟）的「已連結裝置」管理介面撤銷這台機器的存取
- [ ] 瀏覽器（Chrome/Firefox）已登入的 Google/Microsoft 帳號 session 登出，
      尤其若密碼是存在瀏覽器內建密碼庫而非獨立密碼管理器

### 1.6 最後一次完整備份

- [ ] Time Machine 跑一次完整備份到外接（保險用，**不是**用來還原，而是找漏掉的檔案）
- [ ] 家目錄關鍵路徑額外 rsync 一份到 HPSSD

```bash
rsync -av --progress ~/Documents ~/Desktop ~/Pictures ~/Movies /Volumes/HPSSD/mac-migration-20260905/
```

---

## 2. 舊機的技術債清單（新機**不要**再帶過去）

這是這次重灌最大的價值，逐項確認要不要重建：

### 2.1 版本管理器重複

- **問題**：mise 與 nvm 同時安裝，`.zshrc` 只 activate mise，但 `brew leaves` 仍有 nvm，`~/.nvm` 佔 885MB 含 5 個 Node 版本。
- **新機決策**：✅ 只裝 mise，**不裝 nvm**。

### 2.2 `.zshrc` 累積的 PATH 垃圾

現有 `.zshrc` 含這些已不用或不確定的行：

| 行為 | 建議 |
|---|---|
| `export PATH="/usr/local/bin:$PATH"`（Intel 路徑，M 系列用不到） | ❌ 移除 |
| Windsurf PATH (`~/.codeium/windsurf/bin`) | ❓ 確認是否還用 Windsurf |
| Antigravity PATH (`~/.antigravity/antigravity/bin`) | ❓ 目前有 cask，確認保留 |
| kiro shell integration | ❓ 確認是否還用 Kiro |
| `cd ~/Developer/Personal/my-website`（每開 terminal 自動跳） | ❌ 移除，改用 `website` alias |
| `~/.zshrc.backup`、`~/.zshrc.backup.20260101_122256` | ❌ 不要帶 |

### 2.3 AI 工具殘留目錄（共約 2.5GB）

| 目錄 | 大小 | 決策 |
|---|---|---|
| `~/.claude` | 1.0G | ✅ 保留（設定＋memory，資料另外瘦身） |
| `~/.claude-alt` | 229M | ✅ 保留（雙帳號 `cc` 設定，多為 symlink） |
| `~/.windsurf` | 625M | ❓ |
| `~/.codex` | 590M | ❓ |
| `~/.antigravity` | 504M | ❓ |
| `~/.cursor` | 458M | ❓ |
| `~/.kiro` | 290M | ❓ |
| `~/.gemini` | 131M | ❓ |
| `~/.rovodev` `.supermaven` `.codeium` `.qwen` `.copilot` `.aider` `.aider-desk` | 小 | ❓ 多半可棄 |

→ **原則：新機只裝「上個月真的用過」的，其餘等需要再裝。**

### 2.4 應用程式瘦身

**明顯可棄**（舊機遺留、重複、一次性工具）：
`LINE-1.app`（與 LINE 重複）、`Claude 2.app`（與 Claude 重複）、`RunCat` + `RunCatNeo`（二選一）、
`VideoHunter`、`EVPlayer2`、`LMPlayr`、`iMyFone AnyTo`、`Aiarty Image Matting`、`VPN Proxy Master`、
`Epic Games Launcher`、`Humankind`、`Atten`、`TV Remote +`、`NoteOS`、`CleanerCat`、`Jaded`

**需確認**：`Xcode.app`（4GB，但 `xcode-select` 目前指向 Command Line Tools）→ 若沒在做 iOS 開發，**新機只裝 CLT 即可**。

**確定要重裝**：iTerm2、VS Code、Claude Desktop、Chrome、Firefox、Obsidian、Postman、AlDente、MonitorControl、Signal、LINE、Microsoft Office、Cold Turkey Blocker、SelfControl、Adguard、NordVPN、pCloud Drive、IINA、Downie 4、qBittorrent、Steam

### 2.5 開機自動啟動項

`~/Library/LaunchAgents` 有 Epic / Google Updater / Edge Updater / Steam 的自動更新常駐 → 新機不要主動加。

---

## 3. 新機安裝順序（Day 1）

```
1. 開機設定：Apple ID、不勾「從備份轉移」→ 選「稍後設定」
2. 系統更新到最新 macOS
3. 系統設定：
   - 觸控板／鍵盤重複速度（舊機 KeyRepeat 已調快）
   - Dock autohide = true
   - Finder 顯示副檔名、路徑列、狀態列
   - 螢幕鎖定、Touch ID、FileVault 開啟
4. 安裝 Rosetta（若有 Intel-only app）：softwareupdate --install-rosetta
5. Xcode Command Line Tools：xcode-select --install
6. 本 repo 的 bootstrap.sh（Homebrew → Claude Code → mise/Node → git，
   一支腳本做完，不用另外手動裝 Homebrew）
7. clone 本 repo，讓 Claude Code 讀 SETUP_PROMPT.md 接手（見 README）
8. Brewfile 還原：brew bundle --file=Brewfile
9. Oh My Zsh + Powerlevel10k + plugins + zsh-scripts
10. 還原 dotfiles（symlink 方式）
11. mise install（node 22 + uv，透過 scripts/node.sh 覆寫 bootstrap 產生的
    初版 mise 設定——bootstrap 那次不含 uv）
12. **SSH key 輪替（三步驟，每步都要等上一步驗證通過）：**
    1. `ssh-keygen -t ed25519 -C "u88803494@gmail.com"` → `gh auth login`
       → `gh ssh-key add ~/.ssh/id_ed25519.pub`
    2. **驗證**：`ssh -T git@github.com` 成功，且對至少一個私有 repo
       `git pull` 成功
    3. 確認步驟 2 通過後，才去 GitHub Settings → SSH Keys 移除舊機那把 key
       （不要提前做——順序顛倒會造成兩台機器同時 push 不了的空窗期）
13. clone 需要的 repos（不要一次全 clone）
14. VS Code 登入 Settings Sync 或還原 extensions.txt
15. **Claude Code / SuperClaude（詳細步驟見 `config/claude/README.md`，2026-09 這次是空白的最大坑）：**
    1. `pipx install SuperClaude && SuperClaude install --force`（裝 agents + commands/sc）
    2. 手動複製 core/modes/mcp 三批框架檔到 `~/.claude/`（README 裡有指令，`SuperClaude install` 不會處理這批）
    3. 還原 `config/claude/settings.json`、`config/claude/CLAUDE.md` 到 `~/.claude/`
    4. `SuperClaude mcp --servers ...` 重裝 MCP servers（見 §1.3，magic/morphllm-fast-apply/tavily 這三個要繞過 SuperClaude 的 bug，直接呼叫 `claude mcp add`）
    5. 雙帳號：`ln -sf` 把 `~/.claude-alt/{CLAUDE.md,agents,commands,settings.json}` 連到 `~/.claude/` 對應檔案，`~/.claude-shared/mcp.json` 建好（`jq '{mcpServers: (.mcpServers // {})}' ~/.claude.json`），再 `CLAUDE_CONFIG_DIR="$HOME/.claude-alt" claude` 進去 `/login`
16. .zshrc.local 還原 API keys
17. 個人檔案從 HPSSD 選擇性還原
```

---

## 4. 新機的資料衛生策略（避免五年後又爆）

- [ ] **Developer 目錄只放現役專案**，封存專案存 GitHub，本機不留
- [ ] Downloads 設定每 30 天自動清理
- [ ] 定期跑 `brew cleanup`、`pnpm store prune`、`npm cache clean`
- [ ] `~/.cache`（舊機 13GB）納入月度清理
- [ ] Claude Application Support 11GB → 新機定期清 conversation cache
- [ ] 大型媒體檔（Movies/Pictures）直接放 HPSSD 或 pCloud，不放內接

---

## 5. 驗收清單（新機完成後逐項確認）

- [ ] `zsh` 啟動 < 1 秒，p10k 主題正常、無錯誤訊息
- [ ] `node -v` / `pnpm -v` / `mise ls` 正確
- [ ] `git config --get user.email` 正確，`ssh -T git@github.com` 成功
- [ ] `gh auth status` 顯示 `u88803494`
- [ ] `cd ~/Developer/Personal/my-website && pnpm install && pnpm check && pnpm dev` 全過
- [ ] `claude` CLI 可用，`cc` 雙帳號 alias 可用，memory 讀得到
- [ ] MCP servers（serena / context7 / tavily …）連線正常
- [ ] VS Code extensions 齊全、Prettier/ESLint 正常運作
- [ ] iTerm2 設定（字型 MesloLGS NF、配色）正確
- [ ] Time Machine 指向新的備份目的地

**新機穩定運作一段時間後（例如兩週內沒再回頭查舊機資料），回來清理本 repo：**

- [ ] 移除 `Brewfile.old-machine`、`config/shell/.zshrc.old-machine`
      ——這兩份是這次遷移的一次性快照，長期留著只會變成「誰都看不懂為何
      存在」的死檔案，尤其下次換機時它們描述的是**這次**的舊機，不是
      屆時的舊機
- [ ] 確認 `.serena/memories/` 反映的是遷移後的最終狀態

---

## 6. 本 repo 的修正（✅ 已於 2026-09-05 完成）

掃描發現 `my-mac-dev-setup` 與實際環境脫節，已一併修正：

- [x] `README.md` clone 路徑 `~/personal/mac-dev-setup` → `~/Developer/Personal/my-mac-dev-setup`
      （同一批修正也套用到 SETUP_PROMPT.md、bootstrap.sh、config/*/README.md、.serena/memories/）
- [x] `scripts/brew.sh` 改為 `brew bundle --file=Brewfile`
- [x] `scripts/dev-tools.sh`、`scripts/apps.sh` 刪除，內容併入 Brewfile
- [x] `scripts/node.sh` 由 nvm 改為 mise
- [x] `scripts/symlink-zsh.sh` 路徑修正為 `${PERSONAL_DIR:-$HOME/Developer/Personal}/zsh-scripts`
- [x] 新增 `Brewfile`（新機目標狀態，已淘汰項目註解並附原因）
- [x] 新增 `Brewfile.old-machine`（舊機原樣快照，參考用）
- [x] 新增 `config/vscode/`（settings.json + extensions.txt + snippets/）
- [x] 新增 `config/shell/`（.zshrc 乾淨版、.zshrc.old-machine、.zprofile、.gitconfig、.gitignore_global）
- [x] 新增 `config/shell/.zshrc.local.example`（只有 key 名稱，不含值）
- [x] 新增 `config/mise/config.toml`
- [x] 新增 `scripts/macos-defaults.sh`（依舊機實際設定：Dark、Dock autohide、tilesize 64、
      Finder 路徑列＋狀態列＋清單檢視；另加截圖改存 ~/Pictures/Screenshots）
- [x] 新增 `scripts/restore-dotfiles.sh`
- [x] `setup.sh` 重寫為 7 步驟，移除 nvm
- [x] `SETUP_PROMPT.md` 更新為 Brewfile 流程，並加上「不要裝 nvm」的明確指示

**尚未決定、留給你確認的項目**（都在 `Brewfile` 內以註解標示）：
`olets/tap`、`yarn`、`warp`、`antigravity`、`hotovo-aider-desk`、`macfuse`、
`steam`、`downie`、`chatgpt`、`claude`（Desktop）、`openings-mcp`

---

## 7. 建議時程

| 階段 | 內容 | 預估 |
|---|---|---|
| D-7 | §1.1 程式碼全部推上去、§1.2 匯出設定、§6 修正本 repo | 3–4 小時 |
| D-3 | §1.3 秘密收攏、§1.4 個人檔案搬 HPSSD | 2 小時 |
| D-1 | §1.5 反啟用登出、§1.6 完整備份 | 1 小時 |
| D-Day | §3 新機安裝（1–15 步） | 3–4 小時 |
| D+1~7 | 缺什麼裝什麼，§5 驗收 | 隨用隨補 |
