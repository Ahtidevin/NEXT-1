#!/usr/bin/env bash

[ $(getent group docker) ] || groupadd docker
sudo gpasswd -a $(whoami) docker

cd /usr/local/next-discovery

{{ environment_variables }}

# this comes from https://code.google.com/p/lusca-cache/issues/detail?id=89#c4
# http://www.speedguide.net/articles/linux-tweaking-121
# http://stackoverflow.com/questions/11190595/repeated-post-request-is-causing-error-socket-error-99-cannot-assign-reques
sysctl net.ipv4.tcp_tw_recycle=1
sysctl net.ipv4.tcp_tw_reuse=1
sysctl -w net.ipv4.tcp_keepalive_time=300
sysctl -w vm.zone_reclaim_mode=0
sysctl -p

# Turning off transparent huge-paging is recommended by MongoDB (see https://docs.mongodb.com/manual/tutorial/transparent-huge-pages/).
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag

docker-compose down

docker-compose up --build

