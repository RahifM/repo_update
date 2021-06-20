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
git fetch proton --unshallow
git fetch https://github.com/AOSP-whatever/platform_art proton-rvc
git cherry-pick 40ec137a9a26959642f1b50770872aedf3e41517
popd

enter_aosp_dir bionic
git fetch proton --unshallow
git fetch https://github.com/AOSP-whatever/platform_bionic proton-rvc
git cherry-pick d373a3e7221fa4f13fa77fefc19dc6146e691a68^..056bd1dc7bc7e608087b3cb8902cdc839e959dfe
popd

enter_aosp_dir build/make
git fetch proton --unshallow
git fetch https://github.com/AOSP-whatever/platform_build_make proton-rvc
git cherry-pick 5064ed0a5d9157ffe37b9832a708d6bd60f3c3aa^..f9f40970c1608fef66895c363c6e08e6afc39ec3
git cherry-pick f9e78ba3d21c5c1b217de1ac13e5ab832d131bcf^..7c664dccc7d5e508ba6848d8827892eb7e18e6cc
git cherry-pick c38d30ba71ab0583036d9f46b4bff6db7a554d85
git cherry-pick 1393a7ae9c381bd90f074659c4d6d955a73daec8^..6e146cd115dc6341de4f4e6946b704edfdca43b3
git cherry-pick 4735ef881b9679259257682e8a772c93f33a0ca5
popd

enter_aosp_dir build/soong
git fetch proton --unshallow
git fetch https://github.com/AOSP-whatever/platform_build_soong proton-rvc
git cherry-pick 16499c7ecda61ee4636e0474eaf6ef98c386091c^..a15ea49be810bf5052041ef0dd212452285f7afd
git cherry-pick 6d0d0ebe7019539f9519037995f34b740dd89d0a
git cherry-pick 816f983f362c1bfa4be9445bdf299581b00df9ee^..8f1a424600307406414539c1301b7de967066fbe
popd

enter_aosp_dir frameworks/av
git fetch proton --unshallow
git fetch https://github.com/AOSP-whatever/platform_frameworks_av staging/proton-rvc
git cherry-pick 27044422f2334280f8d74f857db703c27bbb46ab^..55dd0d98f2b6473d6fd7292b1c056b4e1e3c02f4
git cherry-pick ba0f04712be065a1dd9f94f4dd0e4fdbfe0d1824
popd

enter_aosp_dir frameworks/base
git fetch proton --unshallow
git fetch https://github.com/AOSP-whatever/platform_frameworks_base rebase/proton-rvc
git cherry-pick e2f5971ce014872d5589f6c7a33a3a8aee8a94cd^..d3fab8a762f85c0f0e152526842c4e2ec5164c15
popd

enter_aosp_dir frameworks/native
git fetch proton --unshallow
git fetch https://github.com/AOSP-whatever/platform_frameworks_native proton-rvc
git cherry-pick d6903b3fbb4837ce4fa42f174dea71ce50b24b5a
git cherry-pick 70c45b4d64e55898bfc55d245752b7c418f9eac8
popd

enter_aosp_dir packages/apps/Launcher3
git fetch proton --unshallow
git fetch https://github.com/AOSP-whatever/platform_packages_apps_Launcher3 proton-rvc
git cherry-pick 43dfaa1f2f75e53a9cbaa5bd16c6619c2d433964
popd

enter_aosp_dir packages/apps/Settings
git fetch proton --unshallow
git fetch https://github.com/AOSP-whatever/platform_packages_apps_Settings proton-rvc
git cherry-pick 3b284ebbc768780a983ac599c24f1e234a54bf44^..a309e660ac99219877774aa747911b7036331b3a
popd

enter_aosp_dir system/core
git fetch proton --unshallow
git fetch https://github.com/AOSP-whatever/platform_system_core proton-rvc
git cherry-pick 18d0deb1d9508d0eb76b3b7effec7b90d425cdd7
git cherry-pick d1259c8bc8f5290a9e9b63c644eeaca72991b63b^..16646952c206ccef6f1b778a23d27d4ba3d58828
popd

enter_aosp_dir system/sepolicy
git fetch proton --unshallow
git fetch https://github.com/AOSP-whatever/platform_system_sepolicy proton-rvc
git cherry-pick b9263dd5aa32fc70a157fd7cf9ecbf743e653c8e
popd

enter_aosp_dir vendor/proton
git fetch proton --unshallow
git fetch https://github.com/AOSP-whatever/android_vendor_proton proton-rvc
git cherry-pick 7d5dbb1a9e5eda8036db923d82d551a13c35395f^..fffd363c68d89797233dfdd345a49c5175e00422
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +eu
