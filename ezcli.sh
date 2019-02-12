#!/bin/bash
#echo $1 $2 $3 $4 $5 $6 $7
#ensXXX ip addr [ADDR] [MASK] gw [GATEWAY]
if [ $# -eq 0 ]
then
	echo ""
	echo "Usage: ezcli [ensXX] ip addr [ADDRESS] [MASK] gw [GATEWAY]"
	echo ""
	echo "========================== "
	ifconfig | grep mtu | awk '{ print $1 }' | grep -v lo >/tmp/nic.tmp
	/sbin/ip add show | grep -w inet | grep -v '127.0.0.1' | awk '{ print $2 }' >/tmp/ip.tmp
	paste /tmp/nic.tmp /tmp/ip.tmp
	echo "========================== "
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
