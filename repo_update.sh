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

#enter_aosp_dir build/make
#git fetch aospa --unshallow
#git fetch https://github.com/AOSP-whatever/platform_build_make staging/pa-ruby
#git cherry-pick a241c651e32e1e900d40879214b2f9a5692c9ea5
#git cherry-pick d5381f2628ea2a038b72d3a7fdb38b16934e7ce1^..7b527b3ba90a80a07b1a0ea94b0e3926d9d31d3d
#popd

enter_aosp_dir device/qcom/common
git fetch aospa --unshallow
git fetch https://github.com/AOSP-whatever/android_device_qcom_common staging/pa-ruby
git cherry-pick 7c4c1e7b79068cb891065c7005b48102ffb6c8ba^..fdad8aea5c29744b88390677d1e072441c4dda06
popd

enter_aosp_dir frameworks/av
git fetch aospa --unshallow
git fetch https://github.com/AOSP-whatever/platform_frameworks_av staging/pa-ruby
git cherry-pick 11d866ca1ce7e53c2b886187960afd6f6564153e^..343b21b7ce805b9773b0d00838c5018302cfcfd9
popd

enter_aosp_dir frameworks/base
git fetch aospa --unshallow
git fetch https://github.com/AOSP-whatever/platform_frameworks_base staging/pa-ruby
git cherry-pick 55279ffbf31010471b67ef9db55721aaca5831a4^..1b1c84cba88d8efd36a6a2d85b2577d506570339
popd

enter_aosp_dir frameworks/native
git fetch aospa --unshallow
git fetch https://github.com/AOSP-whatever/platform_frameworks_native staging/pa-ruby
git cherry-pick afd25cdf5a895a49167cdf42af0e546ac4e00da4
popd

enter_aosp_dir system/sepolicy
git fetch aospa --unshallow
git fetch https://github.com/AOSP-whatever/platform_system_sepolicy staging/pa-ruby
git cherry-pick 5c36bc716c161635a6db45a41d45c9c5c2614c86
popd

enter_aosp_dir vendor/pa
git fetch aospa --unshallow
git fetch https://github.com/AOSP-whatever/android_vendor_pa staging/pa-ruby
git cherry-pick e775309869a9a1ab91954a72350e76571a951a6c^..97b50d953ea2c533c3a8333d1a5fd9bb04756166
popd

enter_aosp_dir vendor/google/pixel
git fetch blobs --unshallow
git fetch https://github.com/RahifM/android_vendor_google_pixel ruby
git cherry-pick 92dc42296c5675edd1167b13155ba8444f4fe575
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +eu
