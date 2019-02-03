#!/usr/bin/env python3

import subprocess
import os

#Ask User for specific timeframe
StartTime = input("Enter a start timeframe, (E.g. 1 hour ago) ")
EndTime = input("Enter an end timeframe, (E.g. Now) ")

#Ask user for what port to filter
Port = input("Enter a sending or destination port number, Or leave blank for any port (E.g. 4242) ")

#Create a subprocess, communicate it to Output and then strip the output into a string
command = ["journalctl","--since",StartTime,"--until",EndTime]
Process = subprocess.Popen(command,stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE)
Output = Process.communicate()
Stdout = Output[0].decode('utf-8').strip()


#Seperate each line into an array, pipe into Runner
runner = Stdout.splitlines()

# Split Array such that each filter is applicable to each iptables filter

InputDropped= []
InputAccepted = []
OutputDropped = []
OutputAccepted = []
ForwardDropped = []
ForwardAccepted = []

#If port is specified, run across if statement
# Check if log-pretext exists in Journalctl entry
#   Then, check to see if the port is also in the array (if user has entered one), if both are true, append it
if Port:
	for item in runner:
		if "INPUT-DROPPED" in item:
			if Port in item:
				InputDropped.append(item)
		elif "INPUT-ACCEPTED" in item:
			if Port in item:
				InputAccepted.append(item)
		elif "OUTPUT-DROPPED" in item:
			if Port in item:
				OutputDropped.append(item)
		elif "OUTPUT-ACCEPTED" in item:
			if Port in item:
				OutputAccepted.append(item)
		elif "FORWARD-DROPPED" in item:
			if Port in item:
				ForwardDropped.append(item)
		elif "FORWARD-ACCEPTED" in item:
			if Port in item:
				ForwardAccepted.append(item)
	os.system('clear')

#If no port is specified, run the same section, just without a port check
#(I know theres an easier way to do this within the same loop, but ¯\_(ツ)_/¯ )
else:
	for item in runner:
		if "INPUT-DROPPED" in item:
			InputDropped.append(item)
		elif "INPUT-ACCEPTED" in item:
			InputAccepted.append(item)
		elif "OUTPUT-DROPPED" in item:
			OutputDropped.append(item)
		elif "OUTPUT-ACCEPTED" in item:
			OutputAccepted.append(item)
		elif "FORWARD-DROPPED" in item:
			ForwardDropped.append(item)
		elif "FORWARD-ACCEPTED" in item:
			ForwardAccepted.append(item)
	os.system('clear')

#Print out all the items in these catagories
print("=================Input Dropped Items=====================")
print("\n".join(InputDropped))
print("=========================================================")

print("\n")
null = input("Press Enter to Continue...")
print("\n")

print("=================Input Accepted Items====================")
print("\n".join(InputAccepted))
print("=========================================================")

print("\n")
null = input("Press Enter to Continue...")
print("\n")

print("=================Output Dropped Items====================")
print("\n".join(OutputDropped))
print("=========================================================")

print("\n")
null = input("Press Enter to Continue...")
print("\n")

print("=================Output Accepted Items===================")
print("\n".join(OutputAccepted))
print("=========================================================")

print("\n")
null = input("Press Enter to Continue...")
print("\n")

print("================Forward Dropped Items====================")
print("\n".join(ForwardDropped))
print("=========================================================")

print("\n")
null = input("Press Enter to Continue...")
print("\n")

print("===============Forward Accepted Items====================")
print("\n".join(ForwardAccepted))
print("=========================================================")

print("\n")
#Request to see if the person wants these in a file, if they do then run through statement
request = input("Would you like this Outputted into a file? (Y/N) ")
if 'y' in request or 'Y' in request:
	#Write logging files for IPTABLES
	inputafile = open("InputAccepted.txt","w+")
	for inputa in InputAccepted:
		inputafile.write(inputa + '\n')
	inputafile.close()

	inputdfile = open("InputDropped.txt","w+")
	for inputd in InputDropped:
		inputdfile.write(inputd + '\n')
	inputdfile.close()

	outputafile = open("OutputAccepted.txt","w+")
	for outputa in OutputAccepted:
		outputafile.write(outputa + '\n')
	outputafile.close()

	outputdfile = open("OutputDropped.txt","w+")
	for outputd in OutputDropped:
		outputdfile.write(outputd + '\n')
	outputdfile.close()

	forwardafile = open("ForwardAccepted.txt","w+")
	for forwarda in ForwardAccepted:
		forwardafile.write(forwarda + '\n')
	forwardafile.close()

	forwarddfile = open("ForwardDropped.txt","w+")
	for forwardd in ForwardDropped:
		forwarddfile.write(forwardd + '\n')
	forwarddfile.close()

print("\n")
