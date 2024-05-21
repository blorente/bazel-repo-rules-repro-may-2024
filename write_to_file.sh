#!/bin/bash -eu
# This file exists because it's the only way to write arbitrary content outside of the workspace.
# I'm not saying this is Bazel-idiomatic, but it works.
content=$1
target=$2
target_dirname=$(dirname "$target")
mkdir -p "$target_dirname"
echo "$content" > "$target"
