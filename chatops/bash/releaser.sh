#!/usr/bin/env bash

# releaser - renames (and encrypts) pentest reports for release
#
# This script is part of the PenText framework
#                            https://pentext.org
#
#    Copyright (C) 2016      Radically Open Security
#                            https://www.radicallyopensecurity.com
#
#                 Author(s): Peter Mosmans
#                            Marcus Bointon
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.


source=target/report-latest.pdf
name=$1
targetdir=target
type=REP
version=1.0

if [ -z ${name} ]; then
    echo "Usage: releaser NAME [version [TYPE]]"
    echo "Names files TYPE-YYYYMMDD-vVERSION-NAME"
    echo "Expects source to be ${source}, and the target directory is ${targetdir}"
    echo "defaults are version=1.0 and TYPE=REP"
    exit 1
fi

[ ! -z $2 ] && version=$2
[ ! -z $3 ] && type=$3

fullname="${targetdir}/${type}-$(date +'%Y%m%d')-v${version}-${name}.pdf"
if [ -f ${source} ]; then
    if [ -f ${fullname} ]; then
        echo "${fullname} already exists. Exiting..."
        exit 1
    else
        cp -v ${source} ${fullname}
        PASS=$(head -c 25 /dev/random | base64 | head -c 25)
        7z a -p${PASS} "${fullname}.zip" ${fullname} 2>/dev/null && echo "Zip file encrypted with password '${PASS}'"
    fi
else
    echo "Could not find source ${source}"
    exit 1
fi
