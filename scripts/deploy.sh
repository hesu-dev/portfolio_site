#!/bin/bash
set -e

DEPLOY_BRANCH="gh-pages"
ROOT_DIR=$(git rev-parse --show-toplevel)
TMP_DIR="$(mktemp -d)"

PROJECT_PATH=$1
if [ -z "$PROJECT_PATH" ]; then
  echo "❌ 사용법: ./scripts/deploy.sh mini_project/saju"
  exit 1
fi

PROJECT_DIR="$ROOT_DIR/$PROJECT_PATH"
TYPE_FILE="$PROJECT_DIR/type.txt"

if [ ! -f "$TYPE_FILE" ]; then
  echo "❌ type.txt 없음"
  exit 1
fi

PROJECT_TYPE=$(cat "$TYPE_FILE" | tr -d '[:space:]')
if [ "$PROJECT_TYPE" != "flutter" ]; then
  echo "❌ flutter 전용 스크립트"
  exit 1
fi

if [ "$(git branch --show-current)" != "main" ]; then
  echo "❌ main 브랜치에서만 실행하세요"
  exit 1
fi

echo "▶ Flutter build 시작"

BASE_HREF="/portfolio_site/$PROJECT_PATH/"

cd "$PROJECT_DIR"
flutter clean
flutter build web \
  --pwa-strategy=none \
  --base-href "$BASE_HREF" \
  --dart-define=API_BASE_URL=https://sunell.dothome.co.kr/api
cd "$ROOT_DIR"

BUILD_DIR="$PROJECT_DIR/build/web"

# ===== 빌드 검증 =====
if [ ! -f "$BUILD_DIR/index.html" ]; then
  echo "❌ build/web/index.html 없음"
  exit 1
fi

echo "✅ Build 성공"

echo "▶ build 결과 임시 보관"
rsync -av "$BUILD_DIR"/ "$TMP_DIR/"

echo "▶ gh-pages로 전환"
git checkout "$DEPLOY_BRANCH"

DEPLOY_TARGET="$PROJECT_PATH"

echo "▶ 기존 배포 제거"
rm -rf "$DEPLOY_TARGET"
mkdir -p "$DEPLOY_TARGET"

echo "▶ index.html을 루트로 복사"
rsync -av --delete \
  --exclude ".git" \
  "$TMP_DIR"/ "$DEPLOY_TARGET/"

git add "$DEPLOY_TARGET"
git commit -m "deploy(flutter): $PROJECT_PATH"
git push origin "$DEPLOY_BRANCH"

echo "▶ main 브랜치로 복귀"
git checkout main

echo "▶ 임시 디렉토리 정리"
rm -rf "$TMP_DIR"

echo
echo "✅ 배포 완료"
echo "🌍 https://hesu-dev.github.io/portfolio_site/$PROJECT_PATH/"


# ./scripts/deploy.sh mini_project/saju
