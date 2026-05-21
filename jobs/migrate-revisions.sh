#!/bin/bash
source constants.sh
shopt -s extglob
set -ev

for DRAFT_CSV in digital-objects/wpp/*/draft/raw/*.csv; do
  rm -rf temp
  mkdir -p temp

  DO_NAME=`echo "$DRAFT_CSV" | perl -pe 's/digital\-objects\/wpp\///g;s/\/draft\/.*//g;'`
  CSV_FILE=`basename $DRAFT_CSV`
  ./src/export-git-revisions.sh $DRAFT_CSV temp

  for EXP_CSV in ../wpp-table-experiments/output_iterative/*/data/WPP\ Input\ Tables/$CSV_FILE; do
    REL_EXP_CSV=`echo "$EXP_CSV" | perl -pe 's/\.\.\/wpp\-table\-experiments\///g;'`
    ./src/export-git-revisions.sh --repo ../wpp-table-experiments "$REL_EXP_CSV" temp
  done

  rm -rf digital-objects/wpp/$DO_NAME/v0.*
  PREV_CSV=""
  for CURRENT_CSV in temp/*.csv; do
    VERSION=`echo $CURRENT_CSV | perl -pe 's/temp\//v0\./g;' | cut -d '-' -f 1`
    DATE_RAW=$(echo "$VERSION" | cut -d '.' -f 2)
    DATE="${DATE_RAW:0:4}-${DATE_RAW:4:2}-${DATE_RAW:6:2}"
    MD_REGEX="s/creation\_date\:.*\n/creation\_date\:\ \"${DATE}\"\n/g;"
        
    RAW_DIR=digital-objects/wpp/$DO_NAME/$VERSION/raw
    if [ -z "$PREV_CSV" ]; then
      echo "First CSV: $CURRENT_CSV $VERSION"

      mkdir -p $RAW_DIR
      cp $CURRENT_CSV $RAW_DIR/$CSV_FILE
      perl -pe "$MD_REGEX" digital-objects/wpp/$DO_NAME/draft/raw/metadata.yaml > $RAW_DIR/metadata.yaml
    fi

    [ -e "$CURRENT_CSV" ] || continue

    if [ -n "$PREV_CSV" ] && ! cmp -s "$PREV_CSV" "$CURRENT_CSV"; then
      echo "CSV differs from previous: $CURRENT_CSV (previous: $PREV_CSV)"

      mkdir -p $RAW_DIR
      cp $CURRENT_CSV $RAW_DIR/$CSV_FILE
      perl -pe "$MD_REGEX" digital-objects/wpp/$DO_NAME/draft/raw/metadata.yaml > $RAW_DIR/metadata.yaml
    fi

    PREV_CSV="$CURRENT_CSV"
  done
done

rm -rf temp
