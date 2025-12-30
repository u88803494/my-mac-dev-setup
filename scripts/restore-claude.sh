#!/bin/bash

# Claude Code 設定恢復腳本
# 用途：在新機器上恢復所有 Claude Code 和 Serena 設定

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$REPO_ROOT/config/claude"

echo "🔄 開始恢復 Claude Code 設定..."

# 檢查 Claude 目錄是否存在
if [ ! -d ~/.claude ]; then
    echo "⚠️  ~/.claude 目錄不存在，正在建立..."
    mkdir -p ~/.claude
fi

# 1. 恢復 settings.json
if [ -f "$BACKUP_DIR/settings.json" ]; then
    echo "📝 恢復 settings.json"
    cp "$BACKUP_DIR/settings.json" ~/.claude/settings.json
else
    echo "⚠️  找不到備份的 settings.json"
fi

# 2. 恢復 CLAUDE.md
if [ -f "$BACKUP_DIR/CLAUDE.md" ]; then
    echo "📝 恢復 CLAUDE.md"
    cp "$BACKUP_DIR/CLAUDE.md" ~/.claude/CLAUDE.md
else
    echo "⚠️  找不到備份的 CLAUDE.md"
fi

# 3. 恢復 settings.local.json（如果存在）
if [ -f "$BACKUP_DIR/settings.local.json" ]; then
    echo "📝 恢復 settings.local.json"
    cp "$BACKUP_DIR/settings.local.json" ~/.claude/settings.local.json
fi

# 4. 恢復 Serena 設定（針對此專案）
if [ -f "$BACKUP_DIR/serena/project.yml" ]; then
    echo "📝 恢復 Serena 專案設定"
    mkdir -p "$REPO_ROOT/.serena"
    cp "$BACKUP_DIR/serena/project.yml" "$REPO_ROOT/.serena/"
fi

# 5. 恢復 Serena memories（針對此專案）
if [ -d "$BACKUP_DIR/serena/memories" ]; then
    echo "📝 恢復 Serena 專案記憶"
    mkdir -p "$REPO_ROOT/.serena/memories"
    cp "$BACKUP_DIR/serena/memories/"*.md "$REPO_ROOT/.serena/memories/" 2>/dev/null || true
fi

echo "✅ 恢復完成！"
echo ""
echo "💡 提醒事項："
echo "   1. 如果尚未安裝 SuperClaude，請執行："
echo "      pipx install SuperClaude"
echo "      SuperClaude install"
echo ""
echo "   2. 檢查 API Keys 是否已設定於 ~/.zshrc.local"
echo ""
echo "   3. 測試 Claude Code："
echo "      claude --version"
