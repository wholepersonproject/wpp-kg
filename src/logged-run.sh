#!/bin/bash
source constants.sh

SCRIPT=$1
LOG=$2

time bash -c "time $SCRIPT 2>&1" | tee -a $LOG
