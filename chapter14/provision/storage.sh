#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl

ARCHIVE="minio.${MINIO_SERVER_VERSION}"
CLIENT="mc.${MINIO_CLIENT_VERSION}"

if ! check_cache_bin "${ARCHIVE}"; then
  get_archive "https://dl.minio.io/server/minio/release/linux-amd64/archive/${ARCHIVE}"
fi

if ! check_cache_bin "${CLIENT}"; then
  get_archive "https://dl.minio.io/client/mc/release/linux-amd64/archive/${CLIENT}"
fi

if ! id minio > /dev/null 2>&1 ; then
  useradd --system minio
fi

install -m 0755 ${CACHE_PATH}/${ARCHIVE} /usr/bin/minio
install -m 0755 ${CACHE_PATH}/${CLIENT} /usr/bin/mc
install -d -m 0755 -o minio -g minio /var/lib/minio/data
install -m 0640 -o minio -g minio -D /vagrant/chapter14/configs/minio/minio /etc/default/
install -m 0644 /vagrant/chapter14/configs/minio/minio.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable minio
systemctl start minio

# Create thanos bucket
sleep 10
echo "Ensuring thanos bucket is available..."
source /etc/default/minio
mc config host add myconfig http://localhost:9000 ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY}
if ! mc ls myconfig/ | grep thanos > /dev/null 2>&1 ; then
  mc mb myconfig/thanos
fi
mc config host rm myconfig
