this_file="${(%):-%x}"
Print() {
  printf "%-9s: %-40s\n" "$1" "$2"
}
#printf "%-10s: %-40s\n", "Sourcing" "${this_file}"
Print "Sourcing" "${this_file}"

# --------------------------------------------
# vars
# --------------------------------------------
ADDON_NAME="MacrobarPlus"
proj_dir=ADDON_NAME
pre_release_dir="$HOME/.wow-pre-release"
dev_release_dir="$HOME/.wow-dev"
EXTLIB="Core/ExtLib"
INTERFACE_LIB="Core/Interface"

#KAPRESOFT_LIB="$HOME/sandbox/github/kapresoft/wow/wow-lib-util/"
#PROJ_CORE_EXTLIB="./Core/ExtLib"
#PROJ_KAPRESOFT_LIB="${PROJ_CORE_EXTLIB}/Kapresoft-LibUtil/"

# --------------------------------------------
# functions
# --------------------------------------------
Validate() {
  local pwd_basename=${PWD:t}
  [ "${pwd_basename}" = "${proj_dir}" ] || \
    (echo "Current dir is \"${pwd_basename}\". Should run script in \"${proj_dir}\" dir." && exit 1)
}

SyncDir() {
  local src="$1"
  local dest="$2"

  if [ ! -d "${src}" ]; then
    echo "[ERROR] Source dir invalid: ${src}"
    return 1
  elif [ ! -d "${dest}" ]; then
    echo "[ERROR] Dest dir invalid: ${dest}"
    return 1
  fi
  Print "Source" "${src}"
  Print "Dest" "${dest}"

  local excludes="--exclude={'.idea','.*','*.sh'}"
  local rsync_opts="--exclude ${excludes} --progress --inplace --out-format=\"[Modified: %M] %o %n%L\""
  local cmd="rsync -aucv ${rsync_opts} ${src} ${dest}"
  echo "Executing: ${cmd}"
  echo "------------------------------------"
  eval "${cmd}"
}
