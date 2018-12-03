#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl tar

ARCHIVE="prometheus-${PROM_VERSION}.linux-amd64.tar.gz"

if ! check_cache "${ARCHIVE}"; then
  get_archive "https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/${ARCHIVE}"
fi

if ! id prometheus > /dev/null 2>&1 ; then
  useradd -m prometheus
fi

tar zxf "${CACHE_PATH}/${ARCHIVE}" -C /home/prometheus --strip-components=1

cp /vagrant/chapter03/configs/prometheus.service /etc/systemd/system/
cp /vagrant/chapter03/configs/prometheus.yml /home/prometheus/ 

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
