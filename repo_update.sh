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

enter_aosp_dir bootable/recovery
git fetch github/hentaiOS --unshallow
git fetch https://github.com/AOSP-whatever/platform_bootable_recovery hos-rika
git cherry-pick 573571cb77d4d69ae720169acd22c1aca336b5ea
popd

enter_aosp_dir build/make
git fetch github/hentaiOS --unshallow
git fetch https://github.com/AOSP-whatever/platform_build_make hos-rika
git cherry-pick c75249e6536ceff3c487e127ab333b1cc073ba02^..f5f039735cba75ac1d6e7e58a1db77cf33961bfd
popd

enter_aosp_dir build/soong
git fetch github/hentaiOS --unshallow
git fetch https://github.com/AOSP-whatever/platform_build_soong hos-rika
git cherry-pick 8cb34d9b498a6d1143cec4a6b87c53dad5564f2f^..e59366c5e641fd630acded007e98c9be34d6160b
popd

enter_aosp_dir frameworks/av
git fetch aosp --unshallow
git fetch https://github.com/AOSP-whatever/platform_frameworks_av hos-rika
git cherry-pick 417665d9af6694b50cd832d4c9e092e1a9be972d^..b640db0ee10379172d7f28c379109dc018018612
popd

enter_aosp_dir frameworks/base
git fetch github/hentaiOS --unshallow
git fetch https://github.com/AOSP-whatever/platform_frameworks_base hos-rika
git cherry-pick 883f512d0513300b708e3a83b5f18c7a42be8adc^..33213dc3d9336ec82e0a429bacf752c3d8a2ead1
popd

enter_aosp_dir hardware/interfaces
git fetch aosp --unshallow
git fetch https://github.com/AOSP-whatever/platform_hardware_interfaces hos-rika
git cherry-pick b49270a8347134826a50baddc699b0b02849782e
popd

enter_aosp_dir packages/apps/Settings
git fetch aosp --unshallow
git fetch https://github.com/AOSP-whatever/platform_packages_apps_Settings hos-rika
git cherry-pick 23f88177870437f4db3843439a85bbcc379c425a^..0dd0ccaeddd22895790b8ad4338c80d9eb868504
popd

enter_aosp_dir system/core
git fetch github/hentaiOS --unshallow
git fetch https://github.com/AOSP-whatever/platform_system_core hos-rika
git cherry-pick bd07a5f62afa3cd5ffb602b5ea84fea742850a7a^..64a170504e7fc74fad747e9b3b054401754c3c3b
popd

enter_aosp_dir system/sepolicy
git fetch aosp --unshallow
git fetch https://github.com/AOSP-whatever/platform_system_sepolicy hos-rika
git cherry-pick 8030ed8403806a3ed36c12e52d340fea71c5c3ab
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +eu
