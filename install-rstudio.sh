#!/usr/bin/env bash
#
# Installs the latest RStudio daily desktop build for OSX/macOS and Ubuntu(amd64)
#
# https://support.rstudio.com/hc/en-us/articles/203842428-Getting-the-newest-RStudio-builds

set -e

# Pass version you want to get, eg one of daily, preview, or stable
VERSION=$1

if [ "$VERSION" = "" ]; then

        echo "Hey, you did not supply a VERSION input! Using stable"
        VERSION="stable"

fi

URL="https://www.rstudio.org/download/latest/"${VERSION}"/desktop/ubuntu64/rstudio-latest-amd64.deb"
PACKAGE=$(basename "${URL}")
TARGET="/tmp/${PACKAGE}"

# If previous file exists (from previous partial download, for example),
# remove it.
if [ -f "${TARGET}" ]; then
    echo -e "A previous package was found. Removing ${TARGET} prior to new download"
    rm "${TARGET}"
fi

echo "Downloading ${VERSION} build from: ${URL}"
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
