#!/usr/bin/env bash

# pull_upstream_changes - Updates repo and applies upstream changes
#
# Copyright (C) 2016-2017 Peter Mosmans [Radically Open Security]
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.


# File which has to exist in the target directory to qualify as target
FINGERPRINT="dtd"
# List of files and directories that need to be updated
SOURCEFILES="dtd xslt source/snippets"
# Root directory within source repo
SOURCEROOT="xml"


## Don't change anything below this line
VERSION=0.7

source=$(dirname $(readlink -f $0))

if [ "$1" == "--force" ]; then
    force=true
    shift
fi

target=$1

if [ -z "$target" ]; then
    target=$(readlink -f .)
    if [ "${target}" == "${source}" ]; then
        echo "Usage: pull_upstream_changes [--force] [TARGET]"
        echo "       or run from within target directory"
        exit
    fi
fi

# Check if the target actually contains the repository
if [ ! -z ${FINGERPRINT} ] && [ ! -d $target/dtd ]; then
    echo "[-] ${target} does not contain the correct repository"
    if [ -z $force ]; then
        exit
    else
        echo "[*] --force option: continuing anyway..."
    fi
fi

# Update repository
echo "[*] Updating source repository (${source})..."
pushd "$source" >/dev/null && git pull && popd >/dev/null

# Only update newer files
echo "[*] Applying changes (if any)..."
for sourcefile in ${SOURCEFILES}; do
    if [ -d "${source}/${SOURCEROOT}/${sourcefile}" ]; then
        if [ ! -z $force ]; then
            mkdir -p ${target}/${sourcefile} 1>/dev/null
        fi
       cp -prv ${source}/${SOURCEROOT}/${sourcefile}/* $target/${sourcefile}/
    else
        cp -pv ${source}/${SOURCEROOT}/${sourcefile} $target/${sourcefile}
    fi
done
echo "[+] Done"

