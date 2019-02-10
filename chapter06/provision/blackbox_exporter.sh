#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl tar

ARCHIVE="blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-amd64.tar.gz"

if ! check_cache "${ARCHIVE}"; then
  get_archive "https://github.com/prometheus/blackbox_exporter/releases/download/v${BLACKBOX_EXPORTER_VERSION}/${ARCHIVE}"
fi

if ! id blackbox_exporter > /dev/null 2>&1 ; then
  useradd --system blackbox_exporter
fi

tar zxf "${CACHE_PATH}/${ARCHIVE}" -C /usr/bin --strip-components=1 --wildcards */blackbox_exporter

install -d -m 0755 -o blackbox_exporter -g blackbox_exporter /etc/blackbox_exporter/
install -m 0644 -D /vagrant/chapter06/configs/blackbox_exporter/blackbox.yml /etc/blackbox_exporter/blackbox.yml
install -m 0644 /vagrant/chapter06/configs/blackbox_exporter/blackbox-exporter.service /etc/systemd/system/
# ICMP probe requires access to raw sockets
setcap cap_net_raw+ep /usr/bin/blackbox_exporter

systemctl daemon-reload
systemctl enable blackbox-exporter
systemctl start blackbox-exporter

