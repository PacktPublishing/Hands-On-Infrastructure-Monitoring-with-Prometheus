#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl tar

ARCHIVE="consul_${CONSUL_VERSION}_linux_amd64.zip"

DEBIAN_FRONTEND=noninteractive apt-get install -y unzip

if ! check_cache_zip "${ARCHIVE}"; then
  get_archive "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/${ARCHIVE}"
fi

if ! id consul > /dev/null 2>&1 ; then
  useradd --system consul
fi

TMPD=$(mktemp -d)
unzip -x "${CACHE_PATH}/${ARCHIVE}" -d "$TMPD"

install -m 0755 $TMPD/consul /usr/bin/
install -m 0644 /vagrant/chapter12/configs/consul/consul.service /etc/systemd/system/

ADDRESS=$(awk '/'"$(hostname)"'/{print $1}' /etc/hosts)
sed -i "s/192\.168\.42\.11/$ADDRESS/" /etc/systemd/system/consul.service

systemctl daemon-reload
systemctl enable consul
systemctl start consul

/vagrant/chapter12/provision/consul_exporter.sh
