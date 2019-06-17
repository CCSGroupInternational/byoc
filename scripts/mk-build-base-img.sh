#!/bin/sh

set -eu

[[ $# != 1 ]] && echo "Usage: $0 install_directory" && exit 1

SETUP_DIR=$1
SCRIPTS_DIR="$(dirname "$0")"

source "$SCRIPTS_DIR/../etc/build-base-image"
mkdir -p "${SETUP_DIR}"

# Download Ubuntu Image's signers public keys to validate image after download
gpg --no-default-keyring --keyring "${SETUP_DIR}/ubuntu-image.gpg" --keyid-format long \
    --keyserver ${GPG_KEYSERVER} --recv-keys ${GPG_SIGNER_KEYS}

mkdir -p "${SETUP_DIR}/sources"
wget -c -P "${SETUP_DIR}/sources" "${IMAGE_URL}"
wget -c -P "${SETUP_DIR}/sources" "${SHA256SUMS}"
wget -c -P "${SETUP_DIR}/sources" "${SHA256SUMS}.gpg"

gpg --no-default-keyring --keyring "${SETUP_DIR}/ubuntu-image.gpg" \
    --keyid-format long \
    --verify "${SETUP_DIR}/sources/SHA256SUMS.gpg" "${SETUP_DIR}/sources/SHA256SUMS"

echo Image is OK