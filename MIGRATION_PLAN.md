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

未提交／未推送的變更（掃描時發現）：

- [ ] `Personal/curves_tool` — 有未提交變更，且**無 git remote**
- [ ] `Personal/zsh-scripts` — `custom.plugin.zsh` 已修改未提交（這個最重要，是 shell 設定來源）
- [ ] `Personal/job-hunting` — 有未追蹤檔案（`strategy/portfolio-decision-panel-20260904.md`）
- [ ] `Personal/market-pulse` — `main.py`、`routers/stock_routes.py` 已修改
- [ ] `Personal/my-dapp-guestbook` — `package.json` 已修改，且**無 remote**
- [ ] `Personal/dictionary` — `.nvmrc` 未追蹤

**無 GitHub remote 的目錄**（不推就會消失）：
`curves_tool`、`movie-ticket-system`、`turbo-test`、`my-dapp-guestbook`、
`interview hw`、`research`、`project-planning`、`references`、`Work/arisan`、`Work/wishmobile`、`Work/eucare`

→ 決策：每個都要選 **(a) 建 private repo 推上去** 或 **(b) 打包丟 HPSSD** 或 **(c) 放棄**。

```bash
# 快速檢查腳本（遷移前跑一次，確認全綠）
find ~/Developer -maxdepth 3 -name .git -type d | while read g; do
  d=$(dirname "$g")
  s=$(git -C "$d" status --porcelain | head -1)
  u=$(git -C "$d" log --branches --not --remotes --oneline 2>/dev/null | head -1)
  [ -n "$s$u" ] && echo "⚠️  $d"
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
```

### 1.3 秘密與憑證（**不進 git**，用 1Password／密碼管理器或加密隨身碟）

- [ ] `~/.zshrc.local` — `MORPH_API_KEY`、`SUPABASE_ACCESS_TOKEN`、`TAVILY_API_KEY`、`PERSONAL_DIR`、`WORK_DIR`
- [ ] `GEMINI_API_KEY`（my-website 開發需要，目前只在 Vercel／專案 `.env.local`）
- [ ] `~/.ssh/id_ed25519` + `.pub`（GitHub 用）→ **建議在新機重新產生一把新 key**，舊 key 從 GitHub 移除
- [ ] `gh` token（存在 keyring）→ 新機直接 `gh auth login` 重新登入即可，不用搬
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

### 1.5 反啟用 / 登出（**遷移前做，事後很麻煩**）

- [ ] Adobe / PhotoDirector 365 / Aiarty 等付費軟體：反啟用授權
- [ ] NordVPN、VPN Proxy Master：確認裝置數上限，登出舊機
- [ ] Steam / Epic：登出（Steam 3.1G 遊戲資料不用搬，重下載）
- [ ] iCloud「尋找」→ 關閉，避免新機啟用鎖問題（Activation Lock 目前為 Enabled）
- [ ] iMessage / FaceTime 登出
- [ ] Signal：先在新機做**裝置連結**，別直接抹掉舊機
- [ ] LINE：確認已綁定 email／電話，聊天記錄先備份

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
6. Homebrew
7. 本 repo 的 bootstrap.sh
8. Brewfile 還原：brew bundle --file=Brewfile
9. Oh My Zsh + Powerlevel10k + plugins + zsh-scripts
10. 還原 dotfiles（symlink 方式）
11. mise install（node 22 + uv）
12. SSH key 新產生 → 加到 GitHub → gh auth login
13. clone 需要的 repos（不要一次全 clone）
14. VS Code 登入 Settings Sync 或還原 extensions.txt
15. Claude Code：還原 ~/.claude 設定與 memory、重新登入雙帳號
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

---

## 6. 本 repo 需要修正的地方（順便做）

掃描發現目前 `my-mac-dev-setup` 與實際環境已脫節：

- [ ] `README.md` 寫 clone 到 `~/personal/mac-dev-setup`，**實際是 `~/Developer/Personal/my-mac-dev-setup`**
- [ ] `scripts/brew.sh` 只裝 pnpm → 應改為 `brew bundle --file=Brewfile`
- [ ] `scripts/apps.sh` 只裝 3 個 app → 應由 Brewfile 統一管理
- [ ] 缺少 `Brewfile`
- [ ] 缺少 `config/vscode/`（settings.json + extensions.txt）
- [ ] 缺少 `config/shell/`（.zshrc、.zprofile、.gitconfig）
- [ ] 缺少 `config/mise/config.toml`
- [ ] `.zshrc.local.example`（只有 key 名稱，不含值）沒有建立
- [ ] `scripts/macos-defaults.sh`（系統偏好設定自動化）不存在
- [ ] `SETUP_PROMPT.md` 需依本計劃更新

---

## 7. 建議時程

| 階段 | 內容 | 預估 |
|---|---|---|
| D-7 | §1.1 程式碼全部推上去、§1.2 匯出設定、§6 修正本 repo | 3–4 小時 |
| D-3 | §1.3 秘密收攏、§1.4 個人檔案搬 HPSSD | 2 小時 |
| D-1 | §1.5 反啟用登出、§1.6 完整備份 | 1 小時 |
| D-Day | §3 新機安裝（1–15 步） | 3–4 小時 |
| D+1~7 | 缺什麼裝什麼，§5 驗收 | 隨用隨補 |
