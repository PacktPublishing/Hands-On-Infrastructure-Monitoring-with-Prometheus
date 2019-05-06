#!/usr/bin/env bash

NETWORK="$1"
DOMAIN="$2"
START_OCTET="$3"

cat <<EOF >/etc/hosts
127.0.0.1       localhost
${NETWORK}${START_OCTET}   shard01${DOMAIN}    shard01
${NETWORK}$((START_OCTET+1))   shard02${DOMAIN}       shard02
${NETWORK}$((START_OCTET+2))   global${DOMAIN}       global

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF
