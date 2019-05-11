#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements git

ARCHIVE="go${GO_VERSION}.linux-amd64.tar.gz"

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y graphviz

if ! check_cache_bin "tsdb" || ! check_cache_bin "pprof" ; then
  if ! check_cache "${ARCHIVE}" ; then
    get_archive "https://dl.google.com/go/${ARCHIVE}"
  fi

  tar zxf "${CACHE_PATH}"/"${ARCHIVE}" -C /usr/lib/

  ln -s /usr/lib/go/bin/go /usr/bin/ || true

  go get github.com/prometheus/tsdb/cmd/tsdb
  install -m 0755 /root/go/bin/tsdb /vagrant/cache/

  go get github.com/google/pprof
  install -m 0755 /root/go/bin/pprof /vagrant/cache/
fi

install -m 0755 /vagrant/cache/tsdb /usr/bin/
install -m 0755 /vagrant/cache/pprof /usr/bin/
