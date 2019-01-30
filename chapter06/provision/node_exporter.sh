#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl tar

ARCHIVE="node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"

if ! check_cache "${ARCHIVE}"; then
  get_archive "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${ARCHIVE}"
fi

if ! id node_exporter > /dev/null 2>&1 ; then
  useradd --system node_exporter
fi

tar zxf "${CACHE_PATH}/${ARCHIVE}" -C /usr/bin --strip-components=1 --wildcards */node_exporter

install -m 0644 /vagrant/chapter06/configs/node_exporter/node-exporter.service /etc/systemd/system/
install -d -m 0755 /var/lib/node_exporter/

systemctl daemon-reload
systemctl enable node-exporter
systemctl start node-exporter

