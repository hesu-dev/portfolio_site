#!/bin/bash
set -e

DEPLOY_BRANCH="gh-pages"
ROOT_DIR=$(git rev-parse --show-toplevel)

PROJECT_PATH=$1
if [ -z "$PROJECT_PATH" ]; then
  echo "❌ 프로젝트 경로를 인자로 넘겨주세요."
  exit 1
fi

PROJECT_DIR="$ROOT_DIR/$PROJECT_PATH"
TYPE_FILE="$PROJECT_DIR/type.txt"

if [ ! -f "$TYPE_FILE" ]; then
  echo "❌ type.txt 없음"
  exit 1
fi

PROJECT_TYPE=$(cat "$TYPE_FILE" | tr -d '[:space:]')
DEPLOY_TARGET="$PROJECT_PATH"

if [ "$(git branch --show-current)" != "main" ]; then
  echo "❌ main 브랜치에서만 실행 가능"
  exit 1
fi

### ===== 빌드 =====
case "$PROJECT_TYPE" in
  flutter)
    BASE_HREF="/portfolio_site/$PROJECT_PATH/"
    cd "$PROJECT_DIR"
    flutter build web \
      --pwa-strategy=none \
      --base-href "$BASE_HREF" \
      --dart-define=API_BASE_URL=https://sunell.dothome.co.kr/api
    BUILD_DIR="$PROJECT_DIR/build/web"
    cd "$ROOT_DIR"
    ;;
  react)
    cd "$PROJECT_DIR"
    npm install
    npm run build
    BUILD_DIR="$PROJECT_DIR/build"
    cd "$ROOT_DIR"
    ;;
  *)
    echo "❌ 알 수 없는 타입"
    exit 1
    ;;
esac

### ===== 빌드 결과 검증 =====
if [ ! -f "$BUILD_DIR/index.html" ]; then
  echo "❌ 빌드 산출물 없음"
  exit 1
fi

echo "✅ Build verified"

### ===== gh-pages 배포 =====
git checkout "$DEPLOY_BRANCH"

rm -rf "$DEPLOY_TARGET"
mkdir -p "$DEPLOY_TARGET"

rsync -av --delete \
  --exclude ".git" \
  "$BUILD_DIR"/ "$DEPLOY_TARGET/"

git add "$DEPLOY_TARGET"
git commit -m "deploy($PROJECT_TYPE): $PROJECT_PATH"
git push origin "$DEPLOY_BRANCH"

git checkout main

echo "✅ Deploy complete (no stash, no delete accident)"


# ./scripts/deploy.sh mini_project/saju
