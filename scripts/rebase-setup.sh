#!/usr/bin/env bash
set -euo pipefail

CHANGE_FILE="rebase.text"

cd "$(git rev-parse --show-cdup)."
git checkout -b rebase

create_file() {
    local i=$1
    local file="${CHANGE_FILE%%.*}${i}.${CHANGE_FILE##*.}"
    echo "This is a file ${i}" > "${file}"
    git add "${file}"
    git commit -m"Add rebase file ${i}" "${file}"
}

add_line() {
    local file_index=$1
    local i=$2
    local file="${CHANGE_FILE%%.*}${file_index}.${CHANGE_FILE##*.}"
    echo "This is line ${i}." >> "${file}"
    git commit -m"Add line ${i} to file ${file_index}" "${file}"
}

create_file 0
create_file 1
for i in $(seq 1 5); do
    for file in $(seq 0 1); do
        add_line $file $i
    done
done
