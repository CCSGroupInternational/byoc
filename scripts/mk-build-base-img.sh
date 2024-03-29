#!/bin/bash

set -eu

[[ $# != 1 ]] && echo "Usage: $0 install_directory" && exit 1

SETUP_DIR=$1
SCRIPTS_DIR="$(realpath $(dirname "$0"))"

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

cd "${SETUP_DIR}/sources"
echo "" #  Improve readability
sha256sum --ignore-missing --strict -c SHA256SUMS
untar_filename=$(echo "${IMAGE_FILENAME}" | sed "s#.gz\$##g")
gzip -dc "${SETUP_DIR}/sources/${IMAGE_FILENAME}" > "${untar_filename}"
udocker import ${SETUP_DIR}/sources/${untar_filename} build-base


udocker=$(udocker create build-base)
udocker run $udocker apt update
udocker run $udocker apt install -y wget build-essential
udocker run $udocker apt install -y libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev libffi-dev uuid-dev zlib1g-dev
cp -vp $SCRIPTS_DIR/python_build.sh ~/.udocker/containers/$udocker/ROOT/root
udocker run $udocker bash -c "cd /root; ./python_build.sh"
