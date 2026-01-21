#!/bin/bash
set -e

### ===== 설정 =====
DEPLOY_BRANCH="gh-pages"
ROOT_DIR=$(git rev-parse --show-toplevel)

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
    (cd "$PROJECT_DIR" && flutter build web --base-href "$BASE_HREF")
    BUILD_DIR="$PROJECT_DIR/build/web"
    ;;
  react)
    (cd "$PROJECT_DIR" && npm install && npm run build)
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

### ===== 배포 =====
echo "▶ Deploy to $DEPLOY_BRANCH"

git checkout "$DEPLOY_BRANCH"

mkdir -p "$DEPLOY_TARGET"

echo "▶ Copy (overwrite only)"
cp -R "$BUILD_DIR"/. "$DEPLOY_TARGET/"

git add "$DEPLOY_TARGET"
git commit -m "deploy($PROJECT_TYPE): $PROJECT_PATH"
git push origin "$DEPLOY_BRANCH"

git checkout main


# set -e
# ./scripts/deploy.sh mini_project/saju