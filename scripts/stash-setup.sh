#!/usr/bin/env bash
set -euo pipefail

CHANGE_FILE="stash.txt"

cd "$(git rev-parse --show-cdup)."
git checkout -b stash-example

create_file() {
    local i=$1
    local nocommit=${2:-}
    local file="${CHANGE_FILE%%.*}${i}.${CHANGE_FILE##*.}"
    echo "This is file ${i}" > "${file}"
    for i in $(seq 1 5); do
        echo "This is line ${i}." >> "${file}"
    done

    if [ "${nocommit}" != "nocommit" ]; then
        git add "${file}"
        git commit -m"Add stash file ${i}" "${file}"
    fi
}

create_file 0
create_file 1
sed -i '' '1i\
This is a new line 1\
' stash0.txt
sed -i '' '3i\
This is a new line 3\
' stash0.txt
create_file 2 nocommit
