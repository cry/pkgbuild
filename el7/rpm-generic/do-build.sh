#!/bin/bash

# This script runs inside the container and actually does the build

shopt -s nullglob

RPMBUILD_HOME='/root/rpmbuild'

if [[ ! -d "${RPMBUILD_HOME}" ]]; then
    echo "${RPMBUILD_HOME} does not exist, are you sure you mounted it?" 2>&1
    exit 1
fi

cd "${RPMBUILD_HOME}"

echo "[+] Options"
echo "[+]   Fetch Sources: $([[ -z ${GET_SOURCES} ]] && echo 'no' || echo 'yes')"
echo "[+]   Install deps:  $([[ -z ${GET_DEPS} ]] && echo 'no' || echo 'yes')"

for spec in SPECS/*.spec; do
    echo "Found ${spec}, building."

    [[ ! -z "${GET_SOURCES}" ]] && spectool -g -R "${spec}" || :

    if [[ ! $? == "0" ]]; then
        echo "Failed to fetch sources, exiting."
        exit 1
    fi

    [[ ! -z "${GET_DEPS}" ]] && yum-builddep -y "${spec}" || :

    if [[ ! $? == "0" ]]; then
        echo "Failed to install build dependencies"
        exit 1
    fi

    rpmbuild -ba "${spec}"
done
