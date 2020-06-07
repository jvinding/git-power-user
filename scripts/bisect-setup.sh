#!/usr/bin/env bash
set -euo pipefail

TEST_SCRIPT="bisect-test.sh"

cd "$(git rev-parse --show-cdup)."
git checkout -b bisect

if [ -x "${TEST_SCRIPT}" ]; then
    echo Test script already exists >&2
    exit 1
fi

create_script() {
    echo "#!/usr/bin/env bash" > "${TEST_SCRIPT}"
    chmod +x "${TEST_SCRIPT}"
    git add "${TEST_SCRIPT}"
    git commit -m'add the test script' "${TEST_SCRIPT}"
}

add_true() {
    echo ":" >> "${TEST_SCRIPT}"
    git commit -m'add another true line to the test script' "${TEST_SCRIPT}"
}

add_false() {
    echo "/bin/false" >> "${TEST_SCRIPT}"
    git commit -m'add another true line to the test script' "${TEST_SCRIPT}"
}

create_script
add_true
add_true
add_true
add_true
add_false
add_false
add_false
add_false
