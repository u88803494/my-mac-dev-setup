#!/bin/bash

# Claude Code 設定備份腳本
# 用途：備份所有 Claude Code 和 Serena 的個人設定

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$REPO_ROOT/config/claude"

echo "🔄 開始備份 Claude Code 設定..."

# 1. 備份 settings.json
if [ -f ~/.claude/settings.json ]; then
    echo "📝 備份 settings.json"
    cp ~/.claude/settings.json "$BACKUP_DIR/settings.json"
else
    echo "⚠️  找不到 ~/.claude/settings.json"
fi

# 2. 備份 CLAUDE.md（SuperClaude 個人設定）
if [ -f ~/.claude/CLAUDE.md ]; then
    echo "📝 備份 CLAUDE.md"
    cp ~/.claude/CLAUDE.md "$BACKUP_DIR/CLAUDE.md"
else
    echo "⚠️  找不到 ~/.claude/CLAUDE.md"
fi

# 3. 備份 settings.local.json（如果存在）
if [ -f ~/.claude/settings.local.json ]; then
    echo "📝 備份 settings.local.json"
    cp ~/.claude/settings.local.json "$BACKUP_DIR/settings.local.json"
fi

# 4. 備份 Serena 設定（針對此專案）
if [ -f "$REPO_ROOT/.serena/project.yml" ]; then
    echo "📝 備份 Serena 專案設定"
    mkdir -p "$BACKUP_DIR/serena"
    cp "$REPO_ROOT/.serena/project.yml" "$BACKUP_DIR/serena/"
fi

# 5. 備份 Serena memories（針對此專案）
if [ -d "$REPO_ROOT/.serena/memories" ]; then
    echo "📝 備份 Serena 專案記憶"
    mkdir -p "$BACKUP_DIR/serena/memories"
    cp "$REPO_ROOT/.serena/memories/"*.md "$BACKUP_DIR/serena/memories/" 2>/dev/null || true
fi

echo "✅ 備份完成！"
echo ""
echo "📦 已備份的檔案："
ls -lh "$BACKUP_DIR"
echo ""
if [ -d "$BACKUP_DIR/serena/memories" ]; then
    echo "📚 Serena 記憶檔："
    ls -lh "$BACKUP_DIR/serena/memories"
fi

echo ""
echo "💡 下一步："
echo "   git add config/claude/"
echo "   git commit -m 'Backup Claude settings'"
echo "   git push"
