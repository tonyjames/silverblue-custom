#!/usr/bin/env bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

rpm-ostree install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${RELEASE}.noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm
  
rpm --import https://downloads.1password.com/linux/keys/1password.asc
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
rpm --import https://dl.google.com/linux/linux_signing_key.pub

EXCLUDED_PACKAGES=$(jq -r ".exclude | (.multimedia[])" /shared/packages.json)
rpm-ostree override remove ${EXCLUDED_PACKAGES}

INCLUDED_PACKAGES=$(jq -r ".include | (.containers[], .fonts[], .misc[], .multimedia[], .virtualization[])" /shared/packages.json)
rpm-ostree install ${INCLUDED_PACKAGES}

EXCLUDED_PACKAGES=$(jq -r ".exclude | (.misc[])" /shared/packages.json)
rpm-ostree override remove ${EXCLUDED_PACKAGES}
