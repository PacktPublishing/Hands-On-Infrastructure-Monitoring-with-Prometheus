CACHE_PATH="/vagrant/cache"

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] ERROR: $*" >&2
}

check_cache() {
  if tar -ztf "${CACHE_PATH}/$1" > /dev/null 2>&1 ; then
    return 0
  else
    return 1
  fi
}

check_cache_deb() {
  if dpkg-deb --info "${CACHE_PATH}/$1" > /dev/null 2>&1 ; then
    return 0
  else
    return 1
  fi
}

check_cache_zip() {
  if unzip -t "${CACHE_PATH}/$1" > /dev/null 2>&1 ; then
    return 0
  else
    return 1
  fi
}

check_cache_bin() {
  if [ -f "${CACHE_PATH}/$1" ] ; then
    return 0
  else
    return 1
  fi
}

get_archive() {
  if cd "${CACHE_PATH}" && curl -sLO "$1" > /dev/null 2>&1 ; then
    return 0
  else
    err "\"$1\" failed to download"
    return 1
  fi
}

check_requirements() {
  for r in "$@"; do
    if hash "${r}" > /dev/null 2>&1; then
      continue
    else
      err "Software requirement \"${r}\" is not available"
      return 1
    fi
  done
}
