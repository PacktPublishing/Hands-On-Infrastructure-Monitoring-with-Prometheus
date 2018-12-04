#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl rsync

ARCHIVE="grafana_${GRAFANA_VERSION}_amd64.deb"

if ! check_cache_deb "${ARCHIVE}"; then
  get_archive "https://s3-us-west-2.amazonaws.com/grafana-releases/release/${ARCHIVE}"
fi

DEBIAN_FRONTEND=noninteractive apt-get install -y libfontconfig
dpkg -i "${CACHE_PATH}/${ARCHIVE}"

rsync -ru /vagrant/chapter03/configs/grafana/{dashboards,provisioning} /etc/grafana/
install -m 0644 /vagrant/chapter03/configs/grafana/hosts /etc/

systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server
