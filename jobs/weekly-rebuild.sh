#!/bin/bash
source constants.sh
shopt -s extglob
set -ev

time jobs/pull-wpp-drafts.sh
time jobs/build-all-wpp-versions.sh
time do-processor build --clean schema/wpp/draft
time do-processor build --clean schema/wpp-metadata/draft
time do-processor build --clean collection/wpp/draft
time do-processor finalize --skip-db
time do-processor create-db --include-all-versions --journal dist/blazegraph.jnl
time jobs/fix-dist-dir.sh
time jobs/deploy.sh
