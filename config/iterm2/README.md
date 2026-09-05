# iTerm2 配置同步

此目錄存放 iTerm2 的配置文件，實現跨機器的設定同步。

## 🔄 自動同步機制

執行 `scripts/iterm2-config.sh` 後，iTerm2 會自動：
- 從此目錄讀取配置
- 將所有修改寫回此目錄
- 保持配置與專案同步

## 📝 首次設定（當前電腦）

```bash
# 1. 匯出當前配置（已完成）
# 2. 執行同步腳本
./scripts/iterm2-config.sh

# 3. 重啟 iTerm2
```

## 🆕 新機器設定

```bash
# 1. Clone 此 repo
git clone https://github.com/u88803494/my-mac-dev-setup.git ~/Developer/Personal/my-mac-dev-setup

# 2. 執行完整安裝（會自動執行 iterm2-config.sh）
cd ~/Developer/Personal/my-mac-dev-setup
./setup.sh

# 3. 重啟 iTerm2
# 配置自動載入！
```

## 🔧 手動配置位置

如果需要手動設定，在 iTerm2 中：
1. 打開 **Preferences** (⌘,)
2. 進入 **General** → **Preferences**
3. 勾選 **Load preferences from a custom folder or URL**
4. 選擇此目錄：`~/Developer/Personal/my-mac-dev-setup/config/iterm2`

## 📁 配置文件

- `com.googlecode.iterm2.plist` - iTerm2 主配置文件
  - 包含所有設定（顏色、字型、快捷鍵等）
  - 自動同步所有偏好設定

## 💡 提示

- 任何在 iTerm2 中的修改都會自動保存到此目錄
- 可以透過 git 追蹤配置的變更歷史
- 換機器時只需 clone repo 並執行 setup.sh
