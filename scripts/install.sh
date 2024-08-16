#!/usr/bin/env bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
INCLUDED_PACKAGES=$(jq -r ".include | (.containers[], .fonts[], .misc[], .multimedia[], .virtualization[])" /shared/packages.json)
EXCLUDED_PACKAGES=$(jq -r ".exclude | (.misc[], .multimedia[])" /shared/packages.json)

rpm-ostree install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${RELEASE}.noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm

rpm-ostree override remove ${EXCLUDED_PACKAGES}

rpm-ostree install ${INCLUDED_PACKAGES}
