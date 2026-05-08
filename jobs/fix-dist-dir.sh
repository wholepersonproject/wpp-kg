#!/bin/bash
source constants.sh
shopt -s extglob
set -euo pipefail

DIR=${DEPLOY_HOME:='./dist'}
STYLE_BLOCK="<style>header, hra-footer { display: none !important }</style></head>"
STYLE_MARKER="header, hra-footer { display: none !important }"

if [[ ! -d "$DIR" ]]; then
  echo "Directory not found: $DIR"
  exit 1
fi

updated=0
skipped=0

while IFS= read -r -d '' file; do
  if grep -q "$STYLE_MARKER" "$file"; then
    ((skipped+=1))
    continue
  fi

  sed -i "s|</head>|$STYLE_BLOCK|g" "$file"
  ((updated+=1))
done < <(find "$DIR" -type f -name "index.html" -print0)

echo "Updated $updated file(s)."
echo "Skipped $skipped file(s) already containing style block."
