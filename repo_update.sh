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
git fetch https://github.com/AOSP-whatever/platform_bootable_recovery hos-rika --depth=2 -j16
git cherry-pick 573571cb77d4d69ae720169acd22c1aca336b5ea
popd

enter_aosp_dir build/make
git fetch https://github.com/AOSP-whatever/platform_build_make hos-rika --depth=11 -j16
git cherry-pick 8b1229f11d6b7258c4120d6251ac87ee68c8160d^..ca5933afb7f333a6acd949552c6734a04fdc7396
popd

enter_aosp_dir build/soong
git fetch https://github.com/AOSP-whatever/platform_build_soong hos-rika --depth=4 -j16
git cherry-pick e45665bc57b7042d8ee0621d32e242c58a106433^..c03482a2ab33061c7c28dd899d33b509f5d7596b
popd

enter_aosp_dir external/tinycompress
git fetch https://github.com/AOSP-whatever/platform_external_tinycompress android-11.0.0 --depth=2 -j16
git cherry-pick 0b4ee126c6b28e613d79761d16a87f2536fd51f6
popd

enter_aosp_dir frameworks/av
git fetch https://github.com/AOSP-whatever/platform_frameworks_av hos-rika --depth=8 -j16
git cherry-pick 417665d9af6694b50cd832d4c9e092e1a9be972d^..b640db0ee10379172d7f28c379109dc018018612
popd

enter_aosp_dir frameworks/base
git fetch https://github.com/AOSP-whatever/platform_frameworks_base hos-rika --depth=14 -j16
git cherry-pick 883f512d0513300b708e3a83b5f18c7a42be8adc^..33213dc3d9336ec82e0a429bacf752c3d8a2ead1
popd

enter_aosp_dir frameworks/native
git fetch https://github.com/AOSP-whatever/platform_frameworks_native hos-rika --depth=2 -j16
git cherry-pick 44f68a979e542d22ad8ddc412fa2225f28f72c6d
popd

enter_aosp_dir hardware/interfaces
git fetch https://github.com/AOSP-whatever/platform_hardware_interfaces android-11.0.0 --depth=3 -j16
git cherry-pick b49270a8347134826a50baddc699b0b02849782e
popd

enter_aosp_dir packages/apps/Settings
git fetch https://github.com/AOSP-whatever/platform_packages_apps_Settings hos-rika --depth=4 -j16
git cherry-pick 23f88177870437f4db3843439a85bbcc379c425a^..0dd0ccaeddd22895790b8ad4338c80d9eb868504
popd

enter_aosp_dir system/core
git fetch https://github.com/AOSP-whatever/platform_system_core hos-rika --depth=3 -j16
git cherry-pick bd07a5f62afa3cd5ffb602b5ea84fea742850a7a^..64a170504e7fc74fad747e9b3b054401754c3c3b
popd

enter_aosp_dir system/sepolicy
git fetch https://github.com/AOSP-whatever/platform_system_sepolicy hos-rika --depth=2 -j16
git cherry-pick 8030ed8403806a3ed36c12e52d340fea71c5c3ab
popd

enter_aosp_dir vendor/hentai
git fetch https://github.com/AOSP-whatever/platform_vendor_hentai hos-rika --depth=3 -j16
git cherry-pick 95a70620ae5c6e678f6a395934f786fd65b2a274^..0441444751216e12946b21c0a33a9e4b5a893b55
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +eu
