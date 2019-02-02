#!/usr/bin/env python3

import subprocess
import os

#Ask User for specific timeframe

StartTime = input("Enter a start timeframe, (E.g. 1 hour ago) ")
EndTime = input("Enter an end timeframe, (E.g. Now) ")
Port = input("Enter a sending or destination port number, Or leave blank for any port (E.g. 4242) ")

#Convert port into parsable item
Port = "PT:" + Port + " "

#Create a subprocess, communicate it to Output and then strip the output into a string
command = ["journalctl","--since",StartTime,"--until",EndTime]
Process = subprocess.Popen(command,stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE)
Output = Process.communicate()
Stdout = Output[0].decode('utf-8').strip()


#Seperate each line into an array, pipe into Runner
runner = Stdout.splitlines()

# Split Array such that each 

InputDropped= []
InputAccepted = []
OutputDropped = []
OutputAccepted = []
ForwardDropped = []
ForwardAccepted = []

for item in runner:
	if "INPUT-DROPPED" in item and Port in item:
		InputDropped.append(item)
	elif "INPUT-ACCEPTED" in item and Port in item:
		InputAccepted.append(item)
	elif "OUTPUT-DROPPED" in item and Port in item:
		OutputDropped.append(item)
	elif "OUTPUT-ACCEPTED" in item and Port in item:
		OutputAccepted.append(item)
	elif "FORWARD-DROPPED" in item and Port in item:
		ForwardDropped.append(item)
	elif "FORWARD-ACCEPTED" in item and Port in item:
		ForwardAccepted.append(item)

os.system('clear')

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
null = input("Would you like this Outputted into a file? (Y/N) ")
print("\n")
