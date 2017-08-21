#!/usr/bin/env bash
#
# Installs the latest RStudio daily desktop build for OSX/macOS and Ubuntu(amd64)
#
# https://support.rstudio.com/hc/en-us/articles/203842428-Getting-the-newest-RStudio-builds

set -e

URL="https://www.rstudio.org/download/latest/preview/desktop/ubuntu64/rstudio-latest-amd64.deb"
PACKAGE=$(basename "${URL}")
TARGET="/tmp/${PACKAGE}"

# If previous file exists (from previous partial download, for example),
# remove it.
if [ -f "${TARGET}" ]; then
    echo -e "Removing existing package file: ${TARGET}"
    rm "${TARGET}"
fi

echo "Downloading daily build from: ${URL}"
if [ -x /usr/bin/curl ] ; then
    curl -L -o "${TARGET}" "${URL}"
elif [ -x /usr/bin/wget ] ; then
    wget -O "${TARGET}" "${URL}"
else
    echo "Unable to obtain the RStudio package: cannot find 'curl' or 'wget'"
    exit 1
fi

echo "Installing ${TARGET}"
LAUNCH=""
if [[ `whoami` != "root" ]]; then
    LAUNCH="sudo"
fi
${LAUNCH} dpkg -i "${TARGET}"

rm "${TARGET}"
