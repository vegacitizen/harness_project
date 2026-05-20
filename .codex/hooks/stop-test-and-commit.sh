#!/usr/bin/env bash
# Stop hook: 자동 테스트 + 자동 commit
# stdout: JSON ONLY (plain text 절대 금지)
# git push 절대 실행 금지

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [ -z "$REPO_ROOT" ]; then
  REPO_ROOT="/home/jamespark/github/harness_project"
fi

LOG="$REPO_ROOT/.codex/hooks/hook.log"
mkdir -p "$(dirname "$LOG")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

log "[HOOK] Stop test and commit started"

# 변경사항 확인
CHANGES=$(git -C "$REPO_ROOT" status --short 2>/dev/null || true)
if [ -z "$CHANGES" ]; then
  log "[HOOK] Stop: 변경사항 없음, commit skip"
  echo '{"continue": true}'
  exit 0
fi

# 변경 파일 목록 수집
CHANGED_FILES=$(git -C "$REPO_ROOT" status --short 2>/dev/null | awk '{print $2}' || true)

FAILURES=()

# HTML / Python 파일 테스트
while IFS= read -r file; do
  [ -z "$file" ] && continue
  FULL_PATH="$REPO_ROOT/$file"

  if [[ "$file" == *.html ]]; then
    [ ! -f "$FULL_PATH" ] && continue
    if [[ "$file" == *index.html* ]]; then
      grep -q "<html" "$FULL_PATH" 2>/dev/null || FAILURES+=("$file: missing <html>")
      grep -q "<head" "$FULL_PATH" 2>/dev/null || FAILURES+=("$file: missing <head>")
      grep -q "<body" "$FULL_PATH" 2>/dev/null || FAILURES+=("$file: missing <body>")
    else
      grep -q "<html" "$FULL_PATH" 2>/dev/null || FAILURES+=("$file: missing <html>")
    fi
  elif [[ "$file" == *.py ]]; then
    [ ! -f "$FULL_PATH" ] && continue
    python3 -m py_compile "$FULL_PATH" 2>/dev/null || FAILURES+=("$file: Python syntax error")
  fi
done <<< "$CHANGED_FILES"

# 테스트 실패 시 block
if [ "${#FAILURES[@]}" -gt 0 ]; then
  REASON=$(IFS="; "; echo "${FAILURES[*]}")
  log "[HOOK] Stop: FAIL - $REASON"
  echo "{\"decision\": \"block\", \"reason\": \"Tests failed: $REASON\"}"
  exit 0
fi

# 테스트 통과 → commit (git push 절대 금지)
git -C "$REPO_ROOT" add . 2>/dev/null
if git -C "$REPO_ROOT" commit -m "auto: Codex generated update" 2>/dev/null; then
  COMMIT_HASH=$(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || echo "unknown")
  log "[HOOK] Stop: commit 완료 - $COMMIT_HASH"
  echo '{"continue": true}'
else
  log "[HOOK] Stop: commit 실패 (변경사항 없거나 오류)"
  echo '{"continue": true}'
fi

exit 0
