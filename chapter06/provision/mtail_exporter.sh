#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl tar

ARCHIVE="mtail_v${MTAIL_EXPORTER_VERSION}_linux_amd64"

if ! check_cache_bin "${ARCHIVE}"; then
  get_archive "https://github.com/google/mtail/releases/download/v${MTAIL_EXPORTER_VERSION}/${ARCHIVE}"
fi

if ! id mtail_exporter > /dev/null 2>&1 ; then
  useradd --system mtail_exporter
fi

install -m 0755 ${CACHE_PATH}/${ARCHIVE} /usr/bin/mtail
install -d -m 0755 -o mtail_exporter -g mtail_exporter /etc/mtail_exporter/
install -m 0644 -D /vagrant/chapter06/configs/mtail_exporter/line_count.mtail /etc/mtail_exporter/
install -m 0644 /vagrant/chapter06/configs/mtail_exporter/mtail-exporter.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable mtail-exporter
systemctl start mtail-exporter

