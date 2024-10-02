#!/bin/bash

set -eu
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
  cd "$here/.."
  {
    find . \
      \( \! -path '**/.*' -a -name '*.gyb' \)
  } | while read file; do
    printf "Creating file: ${file%.gyb}\n"
    $here/gyb --line-directive '' -o "${file%.gyb}" "$file";
  done
)
