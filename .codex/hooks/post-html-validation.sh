#!/usr/bin/env bash
# PostToolUse hook: index.html 기본 HTML 구조 검증
# stdout: Codex PostToolUse JSON (additionalContext)
# stderr: 디버그 메시지 (Codex에 노출되지 않음)

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [ -z "$REPO_ROOT" ]; then
  REPO_ROOT="/home/jamespark/github/harness_project"
fi

LOG="$REPO_ROOT/.codex/hooks/hook.log"
mkdir -p "$(dirname "$LOG")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

log "[HOOK] PostToolUse html validation started"

# stdin JSON 파싱 시도 (실패해도 스크립트 계속 진행)
STDIN_DATA=""
if [ ! -t 0 ]; then
  STDIN_DATA=$(cat 2>/dev/null || true)
fi

# 현재 git 변경 목록에서 index.html 포함 여부 확인
CHANGED=$(git -C "$REPO_ROOT" status --short 2>/dev/null | awk '{print $2}' || true)
if ! echo "$CHANGED" | grep -q "index.html"; then
  log "[HOOK] PostToolUse: index.html 변경 없음, skip"
  echo '{"additionalContext": ""}'
  exit 0
fi

INDEX_HTML="$REPO_ROOT/index.html"

# index.html 존재 확인
if [ ! -f "$INDEX_HTML" ]; then
  log "[HOOK] PostToolUse: FAIL - index.html 파일이 존재하지 않음"
  echo '{"additionalContext": "Validation failed: index.html does not exist"}'
  exit 0
fi

# 필수 HTML 태그 검사
FAILURES=()
grep -q "<html" "$INDEX_HTML" 2>/dev/null || FAILURES+=("missing <html>")
grep -q "<head" "$INDEX_HTML" 2>/dev/null || FAILURES+=("missing <head>")
grep -q "<body" "$INDEX_HTML" 2>/dev/null || FAILURES+=("missing <body>")

if [ "${#FAILURES[@]}" -gt 0 ]; then
  REASON=$(IFS=", "; echo "${FAILURES[*]}")
  log "[HOOK] PostToolUse: FAIL - $REASON"
  echo "{\"additionalContext\": \"HTML validation failed: $REASON\"}"
  exit 0
fi

log "[HOOK] PostToolUse: PASS - index.html 구조 검증 통과"
echo '{"additionalContext": ""}'
exit 0
