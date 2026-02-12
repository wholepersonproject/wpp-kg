#!/bin/bash
source constants.sh
shopt -s extglob
set -ev

for urlFile in `find digital-objects -wholename "digital-objects/*draft/raw/*.url"`; do
  curl -L -o ${urlFile%.url} $(cat $urlFile)
done
