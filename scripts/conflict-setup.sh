#!/usr/bin/env bash
set -euo pipefail

CHANGE_FILE="conflict.txt"

cd "$(git rev-parse --show-cdup)."

create_file() {
    local i=$1
    local nocommit=${2:-}
    echo "This is file ${i}" > "${CHANGE_FILE}"
    for i in $(seq 1 5); do
        echo "This is line ${i}." >> "${CHANGE_FILE}"
    done

    if [ "${nocommit}" != "nocommit" ]; then
        git add "${CHANGE_FILE}"
        git commit -m"Add stash file ${i}" "${CHANGE_FILE}"
    fi
}

git checkout -b conflict0

create_file 0
create_file 1

git checkout -b conflict1

sed -i '' '3i\
This is another new line 3\
' "${CHANGE_FILE}"
git commit -m'change line 3' "${CHANGE_FILE}"

git checkout conflict0
sed -i '' '3i\
This is a new line 3\
' "${CHANGE_FILE}"
git commit -m'I also change line 3' "${CHANGE_FILE}"

git merge conflict1
