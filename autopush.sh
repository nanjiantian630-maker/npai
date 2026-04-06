#!/bin/bash
# 自动提交并推送到 GitHub
cd /home/user/flutter_app

# 检查是否有改动
if git diff --quiet && git diff --staged --quiet; then
  echo "⚠️  没有文件改动，无需提交"
  exit 0
fi

# 生成提交信息（包含改动的文件列表）
CHANGED=$(git diff --name-only HEAD 2>/dev/null | head -5 | tr '\n' ', ' | sed 's/,$//')
if [ -z "$CHANGED" ]; then
  CHANGED=$(git status --short | head -5 | awk '{print $2}' | tr '\n' ', ' | sed 's/,$//')
fi
MSG="✏️ Update: ${CHANGED} - $(date '+%Y-%m-%d %H:%M')"

git add .
git commit -m "$MSG"
# post-commit hook 会自动 push

echo "✅ 已推送到 GitHub: $MSG"
