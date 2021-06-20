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

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +eu
