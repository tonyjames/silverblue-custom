#!/usr/bin/env bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

rpm-ostree install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${RELEASE}.noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm

EXCLUDED_PACKAGES=$(jq -r ".exclude | (.multimedia[])" /shared/packages.json)
rpm-ostree override remove ${EXCLUDED_PACKAGES}

INCLUDED_PACKAGES=$(jq -r ".include | (.containers[], .fonts[], .misc[], .multimedia[])" /shared/packages.json)
rpm-ostree install ${INCLUDED_PACKAGES}

EXCLUDED_PACKAGES=$(jq -r ".exclude | (.misc[])" /shared/packages.json)
rpm-ostree override remove ${EXCLUDED_PACKAGES}
