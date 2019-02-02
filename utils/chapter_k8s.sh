#!/usr/bin/env bash

[[ $1 != chapter??/provision/kubernetes*/README.md ]] && exit 1
[[ ! -f $1 ]] && exit 1

cd $(dirname $1)
bash <(awk '/^```bash$/ {code=1; getline} /^```$/ {code=0} code; /deployment\/prometheus-operator/ {print "sleep 30"}' README.md)
