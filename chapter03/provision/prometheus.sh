#!/usr/bin/env bash
set -xe

# lib validator.sh
useradd -m prometheus

PROM_VERSION="2.5.0"
if [ ! -f "/vagrant/downloads/prometheus-${PROM_VERSION}.linux-amd64.tar.gz" ]; then
  cd /vagrant/downloads && curl -sL "https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz" -O
fi

tar zxf "/vagrant/downloads/prometheus-${PROM_VERSION}.linux-amd64.tar.gz" -C /home/prometheus --strip-components=1

cp /vagrant/chapter03/configs/prometheus.service /etc/systemd/system/
cp /vagrant/chapter03/configs/prometheus.yml /home/prometheus/ 

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
