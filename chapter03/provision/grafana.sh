#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl rsync

ARCHIVE="grafana_${GRAFANA_VERSION}_amd64.deb"

if ! check_cache_deb "${ARCHIVE}"; then
  get_archive "https://dl.grafana.com/oss/release/${ARCHIVE}"
fi

DEBIAN_FRONTEND=noninteractive apt-get install -y libfontconfig
dpkg -i "${CACHE_PATH}/${ARCHIVE}"

rsync -ru /vagrant/chapter03/configs/grafana/{dashboards,provisioning} /etc/grafana/

systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server
