#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl tar

ARCHIVE="consul_exporter-${CONSUL_EXPORTER_VERSION}.linux-amd64.tar.gz"

if ! check_cache "${ARCHIVE}"; then
  get_archive "https://github.com/prometheus/consul_exporter/releases/download/v${CONSUL_EXPORTER_VERSION}/${ARCHIVE}"
fi

if ! id consul_exporter > /dev/null 2>&1 ; then
  useradd --system consul_exporter
fi

tar zxf "${CACHE_PATH}/${ARCHIVE}" -C /usr/bin --strip-components=1 --wildcards */consul_exporter

install -m 0644 /vagrant/chapter12/configs/consul_exporter/consul-exporter.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable consul-exporter
systemctl start consul-exporter
