#!/bin/bash
		
#Flush Tables, Set Forward to Drop and everything else to accept
iptables -F
iptables -X
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

####
# INPUT CHAIN LOGGING
	# Create logging chain for accept packets on INPUT
	iptables -N accept-input
	iptables -A accept-input -j LOG --log-prefix "INPUT-ACCEPTED "
	iptables -A accept-input -j ACCEPT

	# Create logging chain for dropped packets on INPUT
	iptables -N drop-input
	iptables -A drop-input -j LOG --log-prefix "INPUT-DROPPED "
	iptables -A drop-input -j DROP
####

####
# OUTPUT CHAIN LOGGING
	# Create logging chain for accepted packets on OUTPUT
	iptables -N accept-output
	iptables -A accept-output -j LOG --log-prefix "OUTPUT-ACCEPTED "
	iptables -A accept-output -j ACCEPT

	# Create logging chain for drop packets on OUTPUT
	iptables -N drop-output
	iptables -A drop-output -j LOG --log-prefix "OUTPUT-DROPPED " 
	iptables -A drop-output -j DROP
####

####
# FORWARD CHAIN LOGGING
	# Create logging chain for accepted packets on FORWARD
	iptables -N accept-forward
	iptables -A accept-forward -j LOG --log-prefix "FORWARD-ACCEPTED "
	iptables -A accept-forward -j ACCEPT

	# Create logging chain for dropped packets on FORWARD
	iptables -N drop-forward
	iptables -A drop-forward -j LOG --log-prefix "FORWARD-DROPPED "
	iptables -A drop-forward -j DROP
# -------

#- Scenerio 4 -#  
#Configures your firewall to connect to ONLY
	# SCP to the Linux Machine
	# FTP To Windows Server
	# DHCP - 
	# DNS

# DHCP
	# Allow DHCP Forwarding only to WinServ and the Client (Specified via interface)
	iptables -A INPUT -p udp --dport 67:68 --sport 67:68 -j accept-forward
	iptables -A OUTPUT -p udp --dport 67:68 --sport 67:68 -j accept-forward 
	iptables -A FORWARD -p udp --dport 67:68 --sport 67:68 -j accept-forward

# SSH
	# Allow SSH/SCP Traffic to and from Router
	   # DONT ALLOW SSH TRAFFIC
		iptables -A INPUT -p tcp -s 195.165.52.0/26 --dport 3737 -m state --state NEW,ESTABLISHED,RELATED -j drop-input
		iptables -A OUTPUT -p tcp -d 195.165.52.0/26 --sport 3737 -m state --state NEW,RELATED,ESTABLISHED -j drop-output
	   # Allow SCP Traffic
		iptables -A INPUT -p tcp -s 195.165.52.0/26  --dport 7373 -m state --state NEW,ESTABLISHED,RELATED -j accept-input
		iptables -A OUTPUT -p tcp -d 195.165.52.0/26  --sport 7373 -m state --state NEW,ESTABLISHED,RELATED -j accept-output

	# Allow SSH/SCP Traffic anywhere else
	   # DONT ALLOW SSH TRAFFIC
		iptables -A FORWARD -p tcp -s 195.165.52.0/26 --dport 3737 -m state --state NEW,RELATED,ESTABLISHED -j drop-forward
		iptables -A FORWARD -p tcp -d 195.165.52.0/26 --sport 3737 -m state --state NEW,RELATED,ESTABLISHED -j drop-forward
	   # Allow SCP Traffic
		iptables -A FORWARD -p tcp -s 195.165.52.0/26  --dport 7373 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward
		iptables -A FORWARD -p tcp -d 195.165.52.0/26  --sport 7373 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward


# Disable hMail to have access to IMAP and SMTP traffic
   # IMAP
	iptables -A FORWARD -p tcp -s 195.165.52.0/26 --dport 143 -m state --state NEW,ESTABLISHED,RELATED -j drop-forward
	iptables -A FORWARD -p tcp -d 195.165.52.0/26 --sport 143 -m state --state NEW,ESTABLISHED,RELATED -j drop-forward
   # SMTP
	iptables -A FORWARD -p tcp -s 195.165.52.0/26 --dport 25 -m state --state NEW,ESTABLISHED,RELATED -j drop-forward
	iptables -A FORWARD -p tcp -d 195.165.52.0/26 --sport 25 -m state --state NEW,ESTABLISHED,RELATED -j drop-forward
   # SMTP
	iptables -A FORWARD -p tcp -s 195.165.52.0/26 --dport 587 -m state --state NEW,ESTABLISHED,RELATED -j drop-forward
	iptables -A FORWARD -p tcp -d 195.165.52.0/26 --sport 587 -m state --state NEW,ESTABLISHED,RELATED -j drop-forward

# Allow FTP SC4 (Filezilla, Unencrypted) Traffic
	iptables -A FORWARD -p tcp -s 195.165.52.0/26 --dport 20:21 -j accept-forward
	iptables -A FORWARD -p tcp -s 195.165.52.0/26 --sport 20:21 -j accept-forward
	iptabels -A FORWARD -p tcp -d 195.165.52.0/26 --dport 20:21 -j accept-forward
	iptables -A FORWARD -p tcp -d 195.165.52.0/26 --sport 20:21 -j accept-forward
	

# Disable MySQL Traffic
	iptables -A FORWARD -p tcp -s 195.165.52.0/26 --dport 3306 -m state --state NEW,ESTABLISHED,RELATED -j drop-forward
	iptables -A FORWARD -p tcp -d 195.165.52.0/26 --sport 3306 -m state --state NEW,ESTABLISHED,RELATED -j drp[-forward

# Allow Tracert forwarding (Mainly for testing)
	iptables -A FORWARD -p udp -s 195.165.52.0/26 --dport 33434:33534 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward
	iptables -A FORWARD -p udp -d 195.165.52.0/26 --sport 33434:33534 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward

# Disable Apache forwarding (custom port)
	iptables -A FORWARD -p tcp -s 195.165.52.0/26 --dport 4242 -m state --state NEW,RELATED,ESTABLISHED -j drop-forward
	iptables -A FORWARD -p tcp -d 195.165.52.0/26 --sport 4242 -m state --state NEW,RELATED,ESTABLISHED -j drop-forward

# Disable IIS forwarding (custom port)
	iptables -A FORWARD -p tcp -s 195.165.52.0/26 --dport 2424 -m state --state NEW,RELATED,ESTABLISHED -j drop-forward
	iptables -A FORWARD -p tcp -d 195.165.52.0/26 --sport 2424 -m state --state NEW,RELATED,ESTABLISHED -j drop-forward

# Allow Incoming/Outgoing DNS forwarding requests
	   # UDP
		iptables -A FORWARD -p udp --dport 53 -j accept-forward
		iptables -A FORWARD -p udp --sport 53 -j accept-forward
	   # TCP
		iptables -A FORWARD -p tcp --dport 53 -j accept-forward
		iptables -A FORWARD -p tcp --sport 53 -j accept-forward


# Allow ICMP Forwarding (Testing purposes Only)
#iptables -A FORWARD -p ICMP -j ACCEPT

# Now that everything is defined from the destination or source port, 
# we can now deny all other traffic unrelated at the OUTBOUND sector (E.g. incoming from Winserv or Lnxserv to client) as noted in -d
iptables -A FORWARD -d 195.165.52.0/26 -j drop-forward
iptables -A INPUT -j drop-input
iptables -A OUTPUT -j drop-output


# Allow Loopback without prompt
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT


# List new IPTABLES
iptables -L INPUT
iptables -L OUTPUT
iptables -L FORWARD

# Echo back the Scenerio
echo "==========================================="
echo "- Scenerio 4 - "
echo "Configures your firewall to connect to ONLY"
echo "SCP"
echo "FTP TO winserv"
echo "DHCP"
echo "DNS"
echo "==========================================="
