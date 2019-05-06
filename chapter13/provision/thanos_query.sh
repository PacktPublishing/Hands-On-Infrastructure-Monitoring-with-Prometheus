#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl tar

ARCHIVE="thanos-${THANOS_VERSION}.linux-amd64.tar.gz"

if ! check_cache "${ARCHIVE}"; then
  get_archive "https://github.com/improbable-eng/thanos/releases/download/v${THANOS_VERSION}/${ARCHIVE}"
fi

if ! id thanos > /dev/null 2>&1 ; then
  useradd --system thanos
fi

tar zxf "${CACHE_PATH}/${ARCHIVE}" -C /usr/bin --strip-components=1 --wildcards */thanos

install -m 0644 /vagrant/chapter13/configs/thanos/thanos-query.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable thanos-query
systemctl start thanos-query

