#!/usr/bin/env zsh

# Sync sandbox into this workspace

IncludeBase() {
  local fnn="script-functions.sh"
  local fn="dev/${fnn}"
  if [ -f "${fn}" ]; then
    source "${fn}"
  elif [ -f "${fnn}" ]; then
    source "${fnn}"
  else
    echo "${fn} not found" && exit 1
  fi
}
IncludeBase && Validate

# --------------------------------------------
# Vars / Support Functions
# --------------------------------------------
SRC="$HOME/sandbox/github/kapresoft/wow/wow-lib-util/"
DEST="./Core/ExtLib/Kapresoft-LibUtil/"

# --------------------------------------------
# Main
# --------------------------------------------

SyncDir $SRC $DEST

