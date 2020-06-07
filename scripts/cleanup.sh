#!/usr/bin/env bash
set -euo pipefail

git co master

rm -f *.txt bisect-test.sh

git b -D rebase bisect stash-example conflict0 conflict1
