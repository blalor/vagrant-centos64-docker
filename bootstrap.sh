#!/bin/bash

set -x
set -e

if ! rpm -q libcap-devel >/dev/null ; then
    yum -y upgrade
    yum -y install bridge-utils libcap-devel libcgroup
fi

for svc in cgconfig cgred; do
    service ${svc} stop
    chkconfig ${svc} off
done

## need to build lxc from source; the one available in epel-testing doesn't work
## with Docker.
if [ ! -e /usr/local/bin/lxc-version ]; then
    git clone https://github.com/lxc/lxc.git /tmp/lxc
    pushd /tmp/lxc
    ./autogen.sh
    ./configure
    make
    make install
fi

fgrep -q /cgroup /etc/fstab || echo "none        /cgroup        cgroup        defaults    0    0" >> /etc/fstab
mount | fgrep -q /cgroup || mount /cgroup

if [ ! -e /etc/sysctl.d/docker ]; then
    [ -d /etc/sysctl.d ] || mkdir /etc/sysctl.d
    
    echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/docker
fi

bridge_if_dev="docker0"

if [ ! -e /etc/sysconfig/network-scripts/ifcfg-${bridge_if_dev} ]; then
    cat << EOF > /etc/sysconfig/network-scripts/ifcfg-${bridge_if_dev}
DEVICE="${bridge_if_dev}"
ONBOOT="yes"
TYPE="Bridge"
NETMASK="255.255.0.0"
IPADDR="172.88.0.1"
STP="off"
DELAY="0"
EOF
fi

if [ ! -e /etc/sysconfig/iptables ]; then
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    iptables -t nat -A POSTROUTING -o ${bridge_if_dev} -j MASQUERADE
    
    service iptables save
fi

## reloads sysctl
service network restart

if [ ! -e /usr/local/bin/docker ]; then
    # curl -o /usr/local/bin/docker https://get.docker.io/builds/Linux/x86_64/docker-latest 
    cp /vagrant/docker-latest /usr/local/bin/docker
    chmod +x /usr/local/bin/docker
fi

## ignore non-zero exit as daemon's not running
/usr/local/bin/docker version || :

uname -a
