# 程式碼風格與慣例

## Bash 腳本標準

### 腳本標頭
```bash
#!/bin/bash

# 腳本名稱 - 用途說明
# =====================

set -e  # 遇到錯誤就退出
```

**要求**：
- Shebang 行：`#!/bin/bash`
- 描述性標頭說明用途
- `set -e` 讓錯誤時快速失敗

### 視覺回饋
所有腳本使用一致的視覺模式：

```bash
# 區段分隔符（主要步驟）
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Step 1/7: 安裝組件"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 子區段分隔符
echo "════════════════════════════════════════════════════════════"
echo "🔧 子區段名稱"
echo "════════════════════════════════════════════════════════════"
```

### Emoji 使用規範
所有腳本中一致的 emoji 意義：
- ✅ 成功 / 已安裝
- ❌ 錯誤 / 失敗
- ⚠️  警告 / 注意
- 📦 安裝中 / 套件
- 🔧 配置中
- 📥 下載中
- 📝 寫入 / 文檔
- 🧹 清理
- 🗑️  移除中
- 🎉 完成

### 狀態訊息
```bash
echo "✅ 組件已安裝"
echo "📥 正在安裝組件..."
echo "✅ 組件安裝成功"
```

### 錯誤處理
```bash
# 檢查命令是否存在
if command -v brew &> /dev/null; then
    echo "✅ 已安裝"
else
    echo "📥 正在安裝..."
fi

# 適當時抑制錯誤
brew uninstall package 2>/dev/null || echo "  (套件未安裝)"
```

### 變數命名
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # 大寫用於常數
work_email=""                                                 # 小寫用於變數
```

### 架構偵測（Apple Silicon）
```bash
if [[ $(uname -m) == 'arm64' ]]; then
    # Apple Silicon 專用
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
```

### 使用者輸入
```bash
# 確認提示
read -p "確定嗎？(yes/NO): " -r
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "已取消。"
    exit 0
fi

# 單一字元提示
read -p "繼續？(y/N): " -n 1 -r
echo

# 帶預設值的輸入
read -p "輸入名稱 [預設值]: " var_name
var_name=${var_name:-預設值}
```

## 檔案組織

### 腳本模組化
- 每個腳本一個職責
- 清楚、描述性的檔名
- 需要執行權限（`chmod +x`）

### 配置檔案
- 範本使用 `.template` 或佔位值
- 備份原始檔案使用 `.bak` 副檔名
- 清楚記錄佔位符

## 註解

### 標頭註解
必須包含：
- 腳本用途
- 任何前置需求
- 特別注意事項

### 行內註解
```bash
# 為 Apple Silicon Mac 添加 Homebrew 到 PATH
if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
```

## 冪等性

所有腳本必須可安全重複執行：
```bash
# 安裝前總是先檢查
if command -v tool &> /dev/null; then
    echo "✅ 已安裝"
else
    echo "📥 正在安裝..."
    # 安裝邏輯
fi
```

## 退出代碼
- `0` - 成功
- `1` - 使用者取消或錯誤
- `set -e` 自動處理非預期錯誤

## 測試考量
- `cleanup.sh` 對應 `setup.sh` 用於測試
- 腳本應優雅地處理缺少的相依項
- 修改前備份重要檔案
