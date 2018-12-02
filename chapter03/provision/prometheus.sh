#!/usr/bin/env bash
set -xe

# lib validator.sh
PROM_VERSION="2.5.0"
cd /vagrant/downloads && curl -sL "https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz" -O
