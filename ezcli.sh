#!/bin/bash
#Version: 1.0
#echo $1 $2 $3 $4 $5 $6 $7
#ensXXX ip addr [ADDR] [MASK] gw [GATEWAY]
if [ $# -eq 0 ]
then
        echo ""
        echo -e "\e[31mUsage: ezcli [ensXX] ip addr [ADDRESS] [MASK] gw [GATEWAY]\e[0m"
        echo ""
        echo "========================== "
        for DEV in /sys/class/net/*; do
                printf  "%-10s %s\n" ${DEV##*/} $(ip addr show ${DEV##*/} | \
                sed -rne '/inet/s:\s+inet\s+([0-9.]+).*:\1:gp');
        done
        echo ""

        echo "========================== "
        route -n | awk 'NR!=1'
        echo ""
        echo "========================== "
        arp -n
        rm -rf /tmp/nic.tmp /tmp/ip.tmp
        echo ""
        exit 1
fi

[ -d /etc/sysconfig/network-scripts/eth-config-backup/ ] || mkdir /etc/sysconfig/network-scripts/eth-config-backup/

newIP=$4
newPrefix=$5
editNIC=$1
newGW=$7

function changeIP(){
	source /etc/sysconfig/network-scripts/ifcfg-$1
	backupFile="/etc/sysconfig/network-scripts/eth-config-backup/ifcfg-${1}.bak.`date +"%y%d%m-%H%M%S"`"
	cp /etc/sysconfig/network-scripts/ifcfg-${1} ${backupFile}
	egrep -v "IPADDR|PREFIX|GATEWAY" </etc/sysconfig/network-scripts/ifcfg-${1} >/etc/sysconfig/network-scripts/ifcfg-${1}.tmp
	echo "IPADDR=\"$2\"" >>/etc/sysconfig/network-scripts/ifcfg-${1}.tmp
	echo "PREFIX=\"$3\"" >>/etc/sysconfig/network-scripts/ifcfg-${1}.tmp
	echo "GATEWAY=\"$4\"" >>/etc/sysconfig/network-scripts/ifcfg-${1}.tmp
	mv /etc/sysconfig/network-scripts/ifcfg-${1}.tmp /etc/sysconfig/network-scripts/ifcfg-${1}
}

changeIP $editNIC $newIP $newPrefix $newGW
ifdown $editNIC > /dev/null 2>&1
ifup $editNIC > /dev/null 2>&1

echo ""
echo "[IP: $newIP] with [Prefix: $newPrefix] [Gateway: $newGW ]on [NIC: $editNIC] now. Have fun!!"
echo "Your config backup at ${backupFile}"
echo ""
