#!/bin/bash
#IPTABLES Flusher, Clears all Iptables rules and chains and resets to initial INPUT, OUTPUT, FORWARD with ACCEPT

#Flush tables, delete all rules and chains
Iptables -F
Iptables -X

#Just in case, remove all NAT and Mangle tables (For Manjaro and Ubuntu this is needed)
Iptables -t nat -F
Iptables -t nat -X

Iptables -t mangle -F
Iptables -t mangle -X

#Adds default rule of accept to default chains
Iptables -P INPUT ACCEPT
Iptables -P OUTPUT ACCEPT
Iptables -P FORWARD ACCEPT

#Lists new IPTables and end script
Iptables -L -n
