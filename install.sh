#!/bin/bash

USR_LOCAL_DIR="/usr/local"
USR_LOCAL_BIN_DIR="${USR_LOCAL_DIR}/bin"

PROJ_DIR="$(cd $(dirname $0) && pwd)"

swift build -c release
cp "${PROJ_DIR}/.build/release/jiracmd" "${USR_LOCAL_BIN_DIR}/jiracmd"
