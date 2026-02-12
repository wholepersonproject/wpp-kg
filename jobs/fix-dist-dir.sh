#!/bin/bash
source constants.sh
shopt -s extglob
set -euo pipefail

DIR=${DEPLOY_HOME:='./dist'}

# macOS vs GNU sed handling
if sed --version >/dev/null 2>&1; then
  SED_INPLACE=(-i)
else
  SED_INPLACE=(-i '')
fi

find "$DIR" -type f -name "*.html" -exec sed "${SED_INPLACE[@]}" \
  -e 's/logo-text="Human Reference Atlas Knowledge Graph"/logo-text="Whole Person Physiome Knowledge Graph"/g' \
  -e 's/logo-text-small="HRA KG"/logo-text-small="WPP KG"/g' \
  {} +
