#!/usr/bin/env bash

set -e

PYTHON_VERSION=${1}
ARCHITECTURE=${2:-linux/amd64}

CONDA_DIR="/opt/conda"

if [[ "$ARCHITECTURE" == "linux/amd64" ]]; then
  CONDA_INSTALLER="Miniconda3-py311_25.9.1-1-Linux-x86_64.sh"
  CONDA_SHA256="238abad23f8d4d8ba89dd05df0b0079e278909a36e06955f12bbef4aa94e6131"
  CONDA_URL="https://repo.anaconda.com/miniconda"
elif [[ "$ARCHITECTURE" == "linux/arm64" ]]; then
  CONDA_INSTALLER="Miniconda3-py311_25.9.1-1-Linux-aarch64.sh"
  CONDA_SHA256="4e0723b9d76aa491cf22511dac36f4fdec373e41d2a243ff875e19b8df39bf94"
  CONDA_URL="https://repo.anaconda.com/miniconda"
else
  echo "Unsupported architecture $ARCHITECTURE"
fi

mkdir -p /etc/determined/conda.d
mkdir -p "${CONDA_DIR}"

cd /tmp
curl --retry 3 -fsSL -O "${CONDA_URL}/${CONDA_INSTALLER}"
echo "${CONDA_SHA256}  ${CONDA_INSTALLER}" | sha256sum ${CONDA_INSTALLER}
bash "./${CONDA_INSTALLER}" -u -b -p "${CONDA_DIR}"
rm -f "./${CONDA_INSTALLER}"

export CONDA_PLUGINS_AUTO_ACCEPT_TOS=true
conda install python=${PYTHON_VERSION}
# Remove this, since it pushes python (et al) too far forward.
# conda update --prefix ${CONDA_DIR} --all -y
conda clean --all -f -y
