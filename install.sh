#!/bin/bash

USR_LOCAL_DIR=${1:-"/usr/local"}
USR_LOCAL_BIN_DIR="${USR_LOCAL_DIR}/bin"
CMD_NAME="cujira"

PROJ_DIR="$(cd $(dirname $0) && pwd)"

swift build -c release
cp "${PROJ_DIR}/.build/release/${CMD_NAME}" "${USR_LOCAL_BIN_DIR}/${CMD_NAME}"
