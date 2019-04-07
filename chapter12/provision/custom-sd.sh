#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements git

if ! check_cache_bin "custom-sd" ; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y golang-go

  echo "Building custom-sd, this might take a while..."
  go get github.com/prometheus/prometheus/documentation/examples/custom-sd/adapter-usage
  install -m 0755 /root/go/bin/adapter-usage /vagrant/cache/custom-sd
fi

install -m 0755 /vagrant/cache/custom-sd /usr/bin/
