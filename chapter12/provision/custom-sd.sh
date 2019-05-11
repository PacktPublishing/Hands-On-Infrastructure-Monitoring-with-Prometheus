#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements git

ARCHIVE="go${GO_VERSION}.linux-amd64.tar.gz"

if ! check_cache_bin "custom-sd" ; then
  if ! check_cache "${ARCHIVE}" ; then
    get_archive "https://dl.google.com/go/${ARCHIVE}"
  fi

  tar zxf "${CACHE_PATH}"/"${ARCHIVE}" -C /usr/lib/

  ln -s /usr/lib/go/bin/go /usr/bin/ || true

  echo "Building custom-sd, this might take a while..."
  go get github.com/prometheus/prometheus/documentation/examples/custom-sd/adapter-usage
  install -m 0755 /root/go/bin/adapter-usage /vagrant/cache/custom-sd
fi

install -m 0755 /vagrant/cache/custom-sd /usr/bin/
