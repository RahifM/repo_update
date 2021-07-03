#!/bin/bash

# exit script immediately if a command fails or a variable is unset
set -eu

# Some people require insecure proxies
HTTP=https
if [ "${INSECURE_PROXY:-}" = "TRUE" ]; then
    HTTP=http
fi

ANDROOT=$PWD

pushd() {
    command pushd "$@" > /dev/null
}

popd() {
    command popd > /dev/null
}

enter_aosp_dir() {
    [ -z "$1" ] && (echo "ERROR: enter_aosp_dir must be called with at least a path! (and optionally an alternative fetch path)"; exit 1)

    [ "$ANDROOT" != "$PWD" ] && echo "WARNING: enter_aosp_dir was not called from $ANDROOT. Please fix the script to call popd after every block of patches!"

    LINK="$HTTP://android.googlesource.com/platform/${2:-$1}"
    echo "Entering $1"
    pushd "$ANDROOT/$1"
}

#if [ "${SKIP_SYNC:-}" != "TRUE" ]; then
  #  pushd "$ANDROOT/.repo/local_manifests"
 #   git pull
  #  popd
#
 #   repo sync -j8 --current-branch --no-tags
#fi

enter_aosp_dir build/make
git fetch https://github.com/AOSP-whatever/platform_build_make posp-dumaloo-release --depth=3 -j16
git cherry-pick b2100be00f5164a721b01a1666d2338d478e7ef7^..d9a9e5a83ac23ac922944ca11b9b6523503e5f0c
popd

enter_aosp_dir frameworks/base
git fetch https://github.com/AOSP-whatever/platform_frameworks_base posp-dumaloo-release --depth=5 -j16
git cherry-pick 54c5b3a4d6b0c5063720e776240c1fab8a0f3f6e^..17750b29b3b851ab3319b543a88538e42f56470d
popd

enter_aosp_dir packages/apps/Settings
git fetch https://github.com/AOSP-whatever/platform_packages_apps_Settings posp-dumaloo-release --depth=2 -j16
git cherry-pick 58265165410b9273ad7fd916812e912fe66eab13
popd

enter_aosp_dir system/sepolicy
git fetch https://github.com/AOSP-whatever/platform_system_sepolicy posp-dumaloo-release --depth=2 -j16
git cherry-pick 97d57a0a8e5d508488d1a41bf2ece8208de7ceaa
popd

enter_aosp_dir vendor/potato
git fetch https://github.com/AOSP-whatever/platform_vendor_potato posp-dumaloo-release --depth=2 -j16
git cherry-pick 53c2743319e16e17109c8c37636b15ff21844054
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +eu
