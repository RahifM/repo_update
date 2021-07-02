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
git fetch https://github.com/AOSP-whatever/platform_build_make staging/pa-ruby --depth=4 -j16
git cherry-pick 15ad9594e86db6c92b02d32011435e5617613577^..18ed0c3c8c7b1a4525d7c508d7f68c58c43a3706
popd

enter_aosp_dir device/qcom/common
git fetch https://github.com/AOSP-whatever/android_device_qcom_common staging/pa-ruby --depth=5 -j16
git cherry-pick 7c4c1e7b79068cb891065c7005b48102ffb6c8ba^..fdad8aea5c29744b88390677d1e072441c4dda06
popd

enter_aosp_dir frameworks/av
git fetch https://github.com/AOSP-whatever/platform_frameworks_av staging/pa-ruby --depth=8 -j16
git cherry-pick 1d39594f18cd0bd4d0aac1842df6bde032db35cf^..4d43b958f731009444ef63f542169659b092723d
popd

enter_aosp_dir frameworks/base
git fetch https://github.com/AOSP-whatever/platform_frameworks_base staging/pa-ruby --depth=7 -j16
git cherry-pick 55279ffbf31010471b67ef9db55721aaca5831a4^..1b1c84cba88d8efd36a6a2d85b2577d506570339
popd

enter_aosp_dir frameworks/native
git fetch https://github.com/AOSP-whatever/platform_frameworks_native staging/pa-ruby --depth=2 -j16
git cherry-pick f4fc51bc2506914bffe5cb1df9aacef7b1d9cb75
popd

enter_aosp_dir system/sepolicy
git fetch https://github.com/AOSP-whatever/platform_system_sepolicy staging/pa-ruby --depth=2 -j16
git cherry-pick 132e37b110838dcc8a6fa8298a07022b702670e9
popd

enter_aosp_dir vendor/pa
git fetch https://github.com/AOSP-whatever/android_vendor_pa staging/pa-ruby --depth=11 -j16
git cherry-pick e775309869a9a1ab91954a72350e76571a951a6c^..97b50d953ea2c533c3a8333d1a5fd9bb04756166
popd

enter_aosp_dir vendor/google/pixel
git fetch https://github.com/RahifM/android_vendor_google_pixel ruby --depth=2 -j16
git cherry-pick 92dc42296c5675edd1167b13155ba8444f4fe575
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +eu
