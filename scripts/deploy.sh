#!/bin/bash
set -e

### ===== 설정 =====
DEPLOY_BRANCH="gh-pages"
ROOT_DIR=$(git rev-parse --show-toplevel)
WORKTREE_DIR="$ROOT_DIR/.gh-pages-worktree"

PROJECT_PATH=$1
if [ -z "$PROJECT_PATH" ]; then
  echo "❌ 프로젝트 경로를 인자로 넘겨주세요."
  echo "예) ./scripts/deploy.sh mini_project/saju"
  exit 1
fi

PROJECT_DIR="$ROOT_DIR/$PROJECT_PATH"
TYPE_FILE="$PROJECT_DIR/type.txt"

if [ ! -f "$TYPE_FILE" ]; then
  echo "❌ type.txt 없음 (flutter / react)"
  exit 1
fi

PROJECT_TYPE=$(cat "$TYPE_FILE" | tr -d '[:space:]')
DEPLOY_TARGET="$PROJECT_PATH"

### ===== 안전 체크 =====
if [ "$(git branch --show-current)" != "main" ]; then
  echo "❌ main 브랜치에서만 실행 가능합니다."
  exit 1
fi

if [[ "$DEPLOY_TARGET" == "" || "$DEPLOY_TARGET" == "/" ]]; then
  echo "❌ 위험한 배포 경로"
  exit 1
fi

### ===== 빌드 =====
echo "▶ Build ($PROJECT_TYPE)"

case "$PROJECT_TYPE" in
  flutter)
    BASE_HREF="/portfolio_site/$PROJECT_PATH/"
    (
      cd "$PROJECT_DIR" && \
      flutter clean && \
      flutter build web \
        --pwa-strategy=none \
        --base-href "$BASE_HREF" \
        --dart-define=API_BASE_URL=https://sunell.dothome.co.kr/api
    )
    BUILD_DIR="$PROJECT_DIR/build/web"
    ;;
  react)
    (
      cd "$PROJECT_DIR" && \
      npm install && \
      npm run build
    )
    BUILD_DIR="$PROJECT_DIR/build"
    ;;
  *)
    echo "❌ 알 수 없는 프로젝트 타입: $PROJECT_TYPE"
    exit 1
    ;;
esac

if [ ! -d "$BUILD_DIR" ]; then
  echo "❌ 빌드 실패 (결과물 없음)"
  exit 1
fi

### ===== gh-pages worktree 준비 =====
if [ ! -d "$WORKTREE_DIR" ]; then
  echo "▶ Create gh-pages worktree"
  git worktree add "$WORKTREE_DIR" "$DEPLOY_BRANCH"
else
  echo "▶ Reuse existing gh-pages worktree"
fi

### ===== 파일 배포 (git 무관) =====
TARGET_DIR="$WORKTREE_DIR/$DEPLOY_TARGET"

echo "▶ Sync files to gh-pages worktree"
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

rsync -av --delete "$BUILD_DIR"/ "$TARGET_DIR/"

echo
echo "✅ Deploy files prepared."
echo "ℹ️  이제 사람이 직접 커밋/푸시 하세요:"
echo
echo "    cd .gh-pages-worktree"
echo "    git status"
echo "    git add $DEPLOY_TARGET"
echo "    git commit -m \"deploy($PROJECT_TYPE): $PROJECT_PATH\""
echo "    git push origin $DEPLOY_BRANCH"
echo
echo "🚫 이 스크립트는 git commit / push를 절대 수행하지 않습니다."


# ./scripts/deploy.sh mini_project/saju
