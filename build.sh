#!/bin/bash

shopt -s expand_aliases

OUTPUT_IMAGE=tc-lockbox-dc-issue-Tezi
OUTPUT_IMAGE_COMBINED=tc-lockbox-dc-issue-Tezi-combined

TP_LOCKBOX_NAME_SAME_HASH=tc-lockbox-dc-issue-apps-same-hash
TP_LOCKBOX_NAME_DIFFERENT_HASH=tc-lockbox-dc-issue-apps-different-hash

OUTPUT_LOCKBOX_APPS_SAME_HASH=tc-lockbox-dc-issue-lockbox-apps-same-hash
OUTPUT_LOCKBOX_APPS_DIFFERENT_HASH=tc-lockbox-dc-issue-lockbox-apps-different-hash

mkdir -p cache

# patched version to support bridged network
# source tcb-env-setup-lza1.sh -t 3.7.0-lza1 -n

source tcb-env-setup.sh -t 3.7.0

function create_combined () {
    rm -rf cache/$OUTPUT_IMAGE_COMBINED
    rm -rf cache/bundle
    rm -rf cache/$OUTPUT_IMAGE
    torizoncore-builder build --file tcbuild-6.3.0-monthly-8.yaml --set OUTPUT_IMAGE=$OUTPUT_IMAGE
    torizoncore-builder bundle docker-compose-combined.yml --platform linux/arm64 --bundle-directory cache/bundle
    torizoncore-builder combine --bundle-directory cache/bundle cache/tc-lockbox-dc-issue-Tezi cache/$OUTPUT_IMAGE_COMBINED
}
function push_packages () {
    #torizoncore-builder platform push --credentials=.credentials.zip --package-name=tc-lockbox-dc-issue --package-version=0.1.0 base
    torizoncore-builder platform push --canonicalize --credentials=.credentials.zip --package-name=tc-lockbox-dc-issue.lock.yml --package-version=same-hash docker-compose-lockbox-same-hash.yml
    torizoncore-builder platform push --canonicalize --credentials=.credentials.zip --package-name=tc-lockbox-dc-issue.lock.yml --package-version=different-hash docker-compose-lockbox-different-hash.yml
}

function create_lockbox () {
    torizoncore-builder platform lockbox --credentials=.credentials.zip --platform linux/arm64 --output-directory cache/$OUTPUT_LOCKBOX_APPS_SAME_HASH $TP_LOCKBOX_NAME_SAME_HASH
    torizoncore-builder platform lockbox --credentials=.credentials.zip --platform linux/arm64 --output-directory cache/$OUTPUT_LOCKBOX_APPS_DIFFERENT_HASH $TP_LOCKBOX_NAME_DIFFERENT_HASH
}

create_combined
#push_packages
#create_lockbox
