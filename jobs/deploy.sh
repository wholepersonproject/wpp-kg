#!/bin/bash
source constants.sh
shopt -s extglob
set -ev

CLEAN="--delete"

if [ "${CDN_S3_BUCKET}" != "" ]; then
  aws s3 sync --profile wpp --exclude "${DEPLOY_HOME}/.git/*" $CLEAN ${DEPLOY_HOME}/ ${CDN_S3_BUCKET}
fi
