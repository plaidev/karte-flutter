#!/bin/bash -e
function set_tag() {
  local TAG=$1
  git tag $TAG
  git push origin $TAG
}

function has_tag() {
  local TAG=$1
  REMOTE_TAGS=(`git tag`)
  for REMOTE_TAG in ${REMOTE_TAGS[@]}; do
    if [[ $REMOTE_TAG == $TAG ]]; then
      return 1
    fi
  done
  return 0
}

function get_package_version_tag() {
  local PACKAGE=$1
  local VERSION_DES=($(grep "^version" "${PACKAGE}/pubspec.yaml"))
  local VERSION=${VERSION_DES[1]}
  echo "${PACKAGE}-v${VERSION}"
  return 0
}

# Check updated packages
cd `dirname $0`
cd ../

echo "未リリースのパッケージを確認中"
git fetch --tags

PACKAGES=("karte_core" "karte_in_app_messaging" "karte_notification" "karte_variables" "karte_visual_tracking")
TARGET_PACKAGES=()
for PACKAGE in ${PACKAGES[@]}; do
  TAG_VERSION=$(get_package_version_tag $PACKAGE)

  has_tag $TAG_VERSION
  if [ $? -eq 0 ]; then
    echo $TAG_VERSION
    TARGET_PACKAGES+=($PACKAGE)
  fi
done

if [ ${#TARGET_PACKAGES[@]} -eq 0 ]; then
    echo "未リリースのパッケージがありません"
    exit
fi

read -p "上のパッケージ/バージョンをリリースしますか？ (y/N): " yn
case "$yn" in
  [yY]*) ;;
  *) echo "abort." ; exit ;;
esac

for PACKAGE in ${TARGET_PACKAGES[@]}; do
  cd $PACKAGE
  flutter pub publish --dry-run1``
  if [ $? -ne 0 ]; then
    echo "WarningまたはErrorを解消してください"
    exit 1
  fi

  TAG_VERSION=$(get_package_version_tag $PACKAGE)
  set_tag $TAG_VERSION
  cd ..
done

echo "finish"
