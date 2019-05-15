#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl tar

ARCHIVE="thanos-${THANOS_VERSION}.linux-amd64.tar.gz"

if ! check_cache "${ARCHIVE}"; then
  get_archive "https://github.com/improbable-eng/thanos/releases/download/v${THANOS_VERSION}/${ARCHIVE}"
fi

if ! id thanos > /dev/null 2>&1 ; then
  useradd --system thanos
fi

tar zxf "${CACHE_PATH}/${ARCHIVE}" -C /usr/bin --strip-components=1 --wildcards */thanos

install -m 0644 /vagrant/chapter14/configs/thanos/thanos-{query,store,receive,compact}.service /etc/systemd/system/
install -d -m 0755 -o thanos -g thanos /etc/thanos /var/lib/thanos/{store,receive,compact}
install -m 0640 -o thanos -g thanos -D /vagrant/chapter14/configs/thanos/storage.yml /etc/thanos/

systemctl daemon-reload
systemctl enable thanos-query
systemctl start thanos-query

systemctl enable thanos-store
systemctl start thanos-store

systemctl enable thanos-receive
systemctl start thanos-receive

systemctl enable thanos-compact
systemctl start thanos-compact
