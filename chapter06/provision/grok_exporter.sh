#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl tar

ARCHIVE="grok_exporter-${GROK_EXPORTER_VERSION}.linux-amd64.zip"

DEBIAN_FRONTEND=noninteractive apt-get install -y unzip

if ! check_cache_zip "${ARCHIVE}"; then
  get_archive "https://github.com/fstab/grok_exporter/releases/download/v${GROK_EXPORTER_VERSION}/${ARCHIVE}"
fi

if ! id grok_exporter > /dev/null 2>&1 ; then
  useradd --system grok_exporter
fi

TMPD=$(mktemp -d)
unzip -x "${CACHE_PATH}/${ARCHIVE}" -d "$TMPD"

install -d -m 0755 -o grok_exporter -g grok_exporter /etc/grok_exporter/
install -m 0644 -D -t /etc/grok_exporter/patterns $TMPD/grok_exporter-${GROK_EXPORTER_VERSION}.linux-amd64/patterns/*
install -m 0755 $TMPD/grok_exporter-${GROK_EXPORTER_VERSION}.linux-amd64/grok_exporter /usr/bin/
install -m 0644 -D /vagrant/chapter06/configs/grok_exporter/config.yml /etc/grok_exporter/
install -m 0644 /vagrant/chapter06/configs/grok_exporter/grok-exporter.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable grok-exporter
systemctl start grok-exporter

# Add grok example
crontab -l | { cat; echo "*/1 * * * * echo critical"; } | crontab -
