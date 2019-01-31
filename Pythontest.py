#!/usr/bin/env python3

import subprocess
import os

#Ask User for specific timeframe

StartTime = input("Enter a start time, (E.g. 1 hour ago)")
EndTime = input("Enter an end time, (E.g. Now)")

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


#print("===================")
#print("Input Dropped Items"
#print("===================")
print("\n".join(InputDropped))
