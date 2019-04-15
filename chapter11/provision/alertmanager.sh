#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl tar

ARCHIVE="alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz"

if ! check_cache "${ARCHIVE}"; then
  get_archive "https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/${ARCHIVE}"
fi

if ! id alertmanager > /dev/null 2>&1 ; then
  useradd --system alertmanager
fi

TMPD=$(mktemp -d)
tar zxf "${CACHE_PATH}/${ARCHIVE}" -C $TMPD --strip-components=1

install -m 0755 $TMPD/{alertmanager,amtool} /vagrant/chapter11/configs/alertmanager/alertdump /usr/bin/
install -d -o alertmanager -g alertmanager /var/lib/alertmanager
install -m 0644 /vagrant/chapter11/configs/alertmanager/{alertmanager,alertdump}.service /etc/systemd/system/
install -m 0644 -D /vagrant/chapter11/configs/alertmanager/alertmanager.yml /etc/alertmanager/alertmanager.yml
install -m 0644 -D /vagrant/chapter11/configs/alertmanager/example.tmpl /etc/alertmanager/templates/example.tmpl

# Alertmanager cluster membership
ADDRESS=$(awk '/'"$(hostname)"'/{print $1}' /etc/hosts)
sed -i "s/0\.0\.0\.0/$ADDRESS/" /etc/systemd/system/alertmanager.service
sed -i "/$(hostname)/d" /etc/systemd/system/alertmanager.service

systemctl daemon-reload

systemctl enable alertmanager
systemctl start alertmanager

systemctl enable alertdump
systemctl start alertdump
