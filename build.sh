#!/bin/bash

# requirements
if [ hash curl 2>/dev/null ]; then
    echo "command 'curl' is missing!"
    exit 1
fi

if [ hash nuget 2>/dev/null ]; then
    echo "command 'nuget' is missing!"
    exit 1
fi

# variables
CEF_VERSION="91.1.6"
CEF_COMMIT="g8a752eb"
CHROMIUM_VERSION="91.0.4472.77"

DOWNLOAD_FILE="cef.tar.bz2"

EXTRACT_DIR="extract"
OUTPUT_DIR="output"

# https://regex101.com/r/WCk6mp/1
# bash doesn't support a lot of regex, so this looks slightly different
INPUT_REGEX="https:\/\/cef-builds.spotifycdn.com\/cef_binary_([^\+\%]+)(\+|\%2B)([^\+\%]+)(\+|\%2B)chromium-([^_]+)_linux64_minimal\.tar\.bz2"

# use arguments, if any
if [ $# -ne 0 ]; then
    if [ $# -eq 1 ]; then
        if [[ $1 =~ ${INPUT_REGEX} ]]; then
            CEF_VERSION="${BASH_REMATCH[1]}"
            CEF_COMMIT="${BASH_REMATCH[3]}"
            CHROMIUM_VERSION="${BASH_REMATCH[5]}"
        else
            echo "first argument is not a valid CDN URL!"
            exit 1
        fi
    else
        if [ $# -eq 3 ]; then
            CEF_VERSION="$1"
            CEF_COMMIT="$2"
            CHROMIUM_VERSION="$3"
        else
            echo "not enough arguments: $#"
            exit 1
        fi
    fi
fi

echo "CEF_VERSION: ${CEF_VERSION}"
echo "CEF_COMMIT: ${CEF_COMMIT}"
echo "CHROMIUM_VERSION: ${CHROMIUM_VERSION}"

DOWNLOAD_URL="https://cef-builds.spotifycdn.com/cef_binary_${CEF_VERSION}+${CEF_COMMIT}+chromium-${CHROMIUM_VERSION}_linux64_beta_minimal.tar.bz2"
echo "DOWNLOAD_URL: ${DOWNLOAD_URL}"

# script
if [ ! -f ${DOWNLOAD_FILE} ]; then
    echo "downloading binaries from ${DOWNLOAD_URL}"
    curl -o ${DOWNLOAD_FILE} ${DOWNLOAD_URL}
else
    echo "file already exists, skipping download"
fi

if [ ! -d ${EXTRACT_DIR} ]; then
    echo "unzipping ${DOWNLOAD_FILE} to folder ${EXTRACT_DIR}"
    mkdir ${EXTRACT_DIR}
    tar -xjvf ${DOWNLOAD_FILE} -C "./${EXTRACT_DIR}"
else
    echo "files already extracted, skipping extraction"
fi

RELEASE_DIR_NAME="Release"
RESOURCES_DIR_NAME="Resources"
LICENSE_FILE_NAME="LICENSE.txt"

CEF_RELEASE_DIR="$(find ${EXTRACT_DIR} -name ${RELEASE_DIR_NAME})"
CEF_RESOURCES_DIR="$(find ${EXTRACT_DIR} -name ${RESOURCES_DIR_NAME})"
CEF_LICENSE_FILE="$(find ${EXTRACT_DIR} -name ${LICENSE_FILE_NAME})"

if [[ -z ${CEF_RELEASE_DIR} ]]; then
    echo "unable to find folder ${RELEASE_DIR_NAME} in ${EXTRACT_DIR}"
    exit 1
fi

if [[ -z ${CEF_RESOURCES_DIR} ]]; then
    echo "unable to find folder ${RESOURCES_DIR_NAME} in ${EXTRACT_DIR}"
    exit 1
fi

if [[ -z ${CEF_LICENSE_FILE} ]]; then
    echo "unable to find file ${LICENSE_FILE_NAME} in ${EXTRACT_DIR}"
    exit 1
fi

if [ -d ${OUTPUT_DIR} ]; then
    echo "preparing a clean output directory"
    rm -rdf ${OUTPUT_DIR}
fi

echo "creating the output directory"
mkdir ${OUTPUT_DIR}

echo "copying release files"
cp -r "${CEF_RELEASE_DIR}/"* "${OUTPUT_DIR}/"

echo "copying resource files"
cp -r "${CEF_RESOURCES_DIR}/"* "${OUTPUT_DIR}/"

echo "copying license file"
cp ${CEF_LICENSE_FILE} ${OUTPUT_DIR}

echo "running nuget pack"
nuget pack cef.redist.linux64.nuspec -Version ${CEF_VERSION}