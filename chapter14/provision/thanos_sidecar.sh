#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl tar

ARCHIVE="thanos-${THANOS_VERSION}.linux-amd64.tar.gz"

if ! check_cache "${ARCHIVE}"; then
  get_archive "https://github.com/improbable-eng/thanos/releases/download/v${THANOS_VERSION}/${ARCHIVE}"
fi

tar zxf "${CACHE_PATH}/${ARCHIVE}" -C /usr/bin --strip-components=1 --wildcards */thanos

install -m 0644 /vagrant/chapter14/configs/thanos/thanos-sidecar.service /etc/systemd/system/
install -d -m 0750 -o prometheus -g prometheus /etc/thanos
install -m 0640 -o prometheus -g prometheus -D /vagrant/chapter14/configs/thanos/storage.yml /etc/thanos/

systemctl daemon-reload
systemctl enable thanos-sidecar
systemctl start thanos-sidecar

