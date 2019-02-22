# Change CentOS7 IP Shell
A easy shell to change CentOS7 linux IP

### Example usage:
```shell
[root@localhost ~]# ezcli 

Usage: ezcli [ensXX] ip addr [ADDRESS] [MASK] gw [GATEWAY]

========================== 
ens192:	99.99.99.2/24
ens224:	12.1.1.11/24

========================== 
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         99.99.99.1      0.0.0.0         UG    101    0        0 ens192
12.1.1.0        0.0.0.0         255.255.255.0   U     102    0        0 ens224
99.99.99.0      0.0.0.0         255.255.255.0   U     101    0        0 ens192

========================== 
Address                  HWtype  HWaddress           Flags Mask            Iface
12.1.1.31                ether   00:50:56:8e:49:98   C                     ens224
99.99.99.1               ether   00:50:56:8e:f5:6b   C                     ens192
99.99.99.253             ether   00:22:bd:f8:19:ff   C                     ens192
12.1.1.253               ether   00:22:bd:f8:19:ff   C                     ens224
```
