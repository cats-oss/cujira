#!/bin/bash

USR_LOCAL_DIR=${1:-"/usr/local"}
USR_LOCAL_BIN_DIR="${USR_LOCAL_DIR}/bin"
CMD_NAME="cujira"

PROJ_DIR="$(cd $(dirname $0) && pwd)"

swift package tools-version --set-current

SWIFT_VERSION="$(cat Package.swift | grep swift-tools-version: | grep -oE \(\\d\\.\\d\))"
SUPPORTED_MAJOR_VERSION="$(echo ${SWIFT_VERSION} | grep 4)"

if [ -z "${SUPPORTED_MAJOR_VERSION}" ]; then
    echo "Swift ${SWIFT_VERSION} not supported"
    exit;
fi

swift build -c release
cp "${PROJ_DIR}/.build/release/${CMD_NAME}" "${USR_LOCAL_BIN_DIR}/${CMD_NAME}"
