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

enter_aosp_dir art
git fetch https://github.com/AOSP-whatever/platform_art android-11.0.0 #--depth=2 -j16
git cherry-pick 40ec137a9a26959642f1b50770872aedf3e41517

popd

enter_aosp_dir bionic
git fetch https://github.com/AOSP-whatever/platform_bionic android-11.0.0 #--depth=3 -j16
git cherry-pick 1b6159fb39322dc9947c2f30404682e849cb1d2b^..3da17440e377245571d37f2acca2a84285f0efad
popd

enter_aosp_dir bootable/recovery
git fetch https://github.com/AOSP-whatever/platform_bootable_recovery android-11.0.0 #--depth=3 -j16
git cherry-pick 4e5a1dc677e603d644ed4a644f9794979ed3b9a4
popd

enter_aosp_dir build/make
git fetch https://github.com/AOSP-whatever/platform_build_make android-11.0.0# --depth=18 -j16
git cherry-pick 0ca9a1d8525a0160da2659156269220df98436bc^..9197f47f0c77d6f5a6a163e152debbce41a37ad2
git cherry-pick a50df3a2525f02db5f4320019b1d07d30375a2bb^..3404632fc9682a3253d82fff0fe365bf16e8e035
git cherry-pick a20cb752463a9a88fd22ca19ec8db7d5613d6c16^..b0da9bc013b4d33d5913919818d77d9bb386e585
git cherry-pick f42518d393c0375dacc58d074f5a9bc8cb93c0c2
popd

enter_aosp_dir build/soong
git fetch https://github.com/AOSP-whatever/platform_build_soong android-11.0.0# --depth=7 -j16
git cherry-pick d24b0ed11fb1de72d87bd31a0e6d3c31c6baadc3^..5e543846dcc5e807658f9c4123f3e83621776edf
git cherry-pick fea3f874262f96dd1c35ec06ec04fccb3d0482a6^..e37ef8bdebdcbaa89ee126be872695e0dd434fb7
popd

enter_aosp_dir external/perfetto
git fetch https://github.com/AOSP-whatever/platform_external_perfetto android-11.0.0# --depth=14 -j16
git cherry-pick cd79f717a675c0d23bf089a0f1dee6b1e8f25edd
popd

enter_aosp_dir external/tinycompress
git fetch https://github.com/AOSP-whatever/platform_external_tinycompress android-11.0.0# --depth=14 -j16
git cherry-pick 0b4ee126c6b28e613d79761d16a87f2536fd51f6
popd

enter_aosp_dir frameworks/av
git fetch https://github.com/AOSP-whatever/platform_frameworks_av staging/android-11.0.0_r38# --depth=14 -j16
git cherry-pick 27044422f2334280f8d74f857db703c27bbb46ab^..55dd0d98f2b6473d6fd7292b1c056b4e1e3c02f4
git cherry-pick 32c4bfe8e4a14f551bb72aa4d541080dda49254c
popd

enter_aosp_dir frameworks/base
git fetch https://github.com/AOSP-whatever/platform_frameworks_base rebase/android-11.0.0_r38 #--depth=14 -j16
git cherry-pick 7c2dfb26266cca97e97669a79abf9469909f6455^..f24ae1246e22c624426b01d55adc1dee778eea2a
popd

enter_aosp_dir frameworks/native
git fetch https://github.com/AOSP-whatever/platform_frameworks_native android-11.0.0# --depth=3 -j16
git cherry-pick d0b5b22319d1ae9e441c22fcea35967f57d241a8^..7aab0b9fd04e0a91f0f3720ac480f6059be38824
popd

enter_aosp_dir frameworks/opt/net/wifi
git fetch https://github.com/AOSP-whatever/platform_frameworks_opt_net_wifi android-11.0.0# --depth=3 -j16
git cherry-pick 0394a575899a9224fb7718b5aaa07092b0f54d3e^..866d67c680e71919d6e7dd2beec869e0ca696cad
popd

enter_aosp_dir hardware/interfaces
git fetch https://github.com/AOSP-whatever/platform_hardware_interfaces android-11.0.0# --depth=3 -j16
git cherry-pick b49270a8347134826a50baddc699b0b02849782e
popd

enter_aosp_dir hardware/libhardware
git fetch https://github.com/AOSP-whatever/platform_hardware_libhardware android-11.0.0# --depth=3 -j16
git cherry-pick 8d0b681485e7fcf8ac108c0e679924f903c9a165^..2688132d1eeaab53ed097b6c0fee9f9a853a0073
popd

enter_aosp_dir packages/apps/Launcher3
git fetch https://github.com/AOSP-whatever/platform_packages_apps_Launcher3 android-11.0.0# --depth=2 -j16
git cherry-pick dd4f7bc8881669d9d64711d7acc98c2e4a138cf5
popd

enter_aosp_dir packages/apps/Settings
git fetch https://github.com/AOSP-whatever/platform_packages_apps_Settings android-11.0.0 #--depth=3 -j16
git cherry-pick 1a210eb791bd1cac7f6fb2ee8012965caf420e2c^..3e18c1ce0d842fec98cd9dac0a2b22f0dfde2e2f
git cherry-pick bf90dff2c2562051fbb0447fc7ec2e7d4a5667f9
popd

enter_aosp_dir packages/apps/SettingsIntelligence
git fetch https://github.com/AOSP-whatever/platform_packages_apps_SettingsIntelligence android-11.0.0 #--depth=3 -j16
git cherry-pick 7fddd910b83bb5b86c42ed0f995f89493452dccd
popd

enter_aosp_dir platform_testing
git fetch https://github.com/AOSP-whatever/platform_platform_testing android-11.0.0 #--depth=3 -j16
git cherry-pick a3449c9d39b9f0fc9fe608b816b4471dabf83d39
popd

enter_aosp_dir system/core
git fetch https://github.com/AOSP-whatever/platform_system_core android-11.0.0 #--depth=5 -j16
git cherry-pick 001a0aceece2d7c5ea922fa505de9c455ee5258f^..6f35e09d91abefe242afea4d93d5a8a4aa68bb35
git cherry-pick 60a3c5ee4b21b3e159b20b53783002e0c9a734dd
popd

enter_aosp_dir system/sepolicy
git fetch https://github.com/AOSP-whatever/platform_system_sepolicy android-11.0.0 #--depth=2 -j16
git cherry-pick e89583f4fa1651d19d6b332f7f474780076e8694
popd

enter_aosp_dir system/vold
git fetch https://github.com/AOSP-whatever/platform_system_vold android-11.0.0 #--depth=3 -j16
git cherry-pick 3336dc31f95b694a8b450bb8ed776b4b1c3eeb13^..ef1ce966df652e4373661e38ce9a172d2c4e3a62
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +eu
