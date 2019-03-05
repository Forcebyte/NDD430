#!/bin/bash

# Flush Tables, Set Forward to Drop and everything else to accept
iptables -F
iptables -X

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# INPUT
	# Create logging chain for accept packets on INPUT
	iptables -N accept-input
	iptables -A accept-input -j LOG --log-prefix "INPUT-ACCEPTED "
	iptables -A accept-input -j ACCEPT

	# Create logging chain for dropped packets on INPUT
	iptables -N drop-input
	iptables -A drop-input -j LOG --log-prefix "INPUT-DROPPED "
	iptables -A drop-input -j DROP

# OUTPUT
	# Create logging chain for accepted packets on OUTPUT
	iptables -N accept-output
	iptables -A accept-output -j LOG --log-prefix "OUTPUT-ACCEPTED "
	iptables -A accept-output -j ACCEPT

	# Create logging chain for dropped packets on OUTPUT
	iptables -N drop-output
	iptables -A drop-output -j LOG --log-prefix "OUTPUT-DROPPED " 
	iptables -A drop-output -j DROP
	
# LOGGING
	# Create logging chain for accepted packets on FORWARD
	iptables -N accept-forward
	iptables -A accept-forward -j LOG --log-prefix "FORWARD-ACCEPTED "
	iptables -A accept-forward -j ACCEPT

	# Create logging chain for dropped packets on FORWARD
	iptables -N drop-forward
	iptables -A drop-forward -j LOG --log-prefix "FORWARD-DROPPED "
	iptables -A drop-forward -j DROP
# -------


# Allow DHCP Forwarding
iptables -A FORWARD -i ens33 -p udp --dport 67:68 --sport 67:68 -j accept-forward
iptables -A FORWARD -i ens37 -p udp --dport 67:68 --sport 67:68 -j accept-forward

# Allow Tracert forwarding
iptables -A FORWARD -p udp --dport 33434:33534 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward
iptables -A FORWARD -p udp --dport 33434:33534 -j accept-forward

# Allow Apache forwarding (custom port)
iptables -A FORWARD -p tcp --dport 4242 --sport 4242 -j accept-forward

# Allow IIS forwarding (custom port)
iptables -A FORWARD -p tcp --dport 2424--sport 2424 -j accept-forward

# Allow Incoming/Outgoing DNS forwarding requests
iptables -A FORWARD -p udp --dport 53 -j accept-forward
iptables -A FORWARD -p udp --sport 53 -j accept-forward

iptables -A FORWARD -p tcp --dport 53 -j accept-forward
iptables -A FORWARD -p tcp --sport 53 -j accept-forward
# Allow Everything else
iptables -A INPUT -j accept-input
iptables -A OUTPUT -j accept-output

# Allow ICMP Forwarding
iptables -A FORWARD -p ICMP -j ACCEPT

# Send everything else to forward-drop
iptables -A FORWARD -j drop-forward

# Allow Loopback without prompt
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#List new IPTABLES
iptables -L -n

#This will allow DNS, IIS, TRACERT, DHCP, and Apache forwarding while logging. Note that I've also allowed ICMP to pass
