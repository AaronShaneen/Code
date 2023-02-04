#!/usr/bin/python

import sys
import shlex
import random

# Declaring variables
randomFiles = {}
randomData = {}

# Checking for number of args passed to script
if len(sys.argv) != 4:
	print("Usage: filemaker INPUTCOMMANDFILE OUTPUTFILE RECORDCOUNT")
	exit(1)

# Verifying record count is a number
try:
	recordCount = int(sys.argv[3])
except Exception as thrownError:
	print("Error, RECORDCOUNT must be an integer: " + str(thrownError))
	exit(1)

# Try to connect to command file
try:
	inputFile = open(sys.argv[1], 'r')
except Exception as thrownError:
	print("Error connecting to " + str(sys.argv[1]) + ": " + str(thrownError))
	exit(1)

# Try to connect to output file
try:
	outputFile = open(sys.argv[2], 'w')
except Exception as thrownError:
	print("Error connecting to " + str(sys.argv[2]) + ": " + str(thrownError))
	exit(1)

# Slurp command file into list for initial processing
commandsList = inputFile.readlines()
ifHeader = shlex.split(commandsList[0])

# Check if first element is a HEADER, if it is write it and discard
if ifHeader[0] == "HEADER":
	outputFile.write(ifHeader[1].decode('string_escape'))

# Shlex the rest of the command file, testing for FILEWORD to create randomFiles
for i in range(len(commandsList)):
	ifFileword = shlex.split(commandsList[i])	
	if ifFileword == "FILEWORD":
		namesFile = open(ifFileword[2], 'r')
		randomFiles[ifFileword[1]] = namesFile.readlines()
		namesFile.close()

# Close input file stream
inputFile.close()

# Generate random data and output
for i in range(recordCount):
	randomData = {}
	for j in range(len(commandsList)):
		command = shlex.split(commandsList[j])
		if command[0] == "STRING":
			outputFile.write(command[1].decode('string_escape'))
		if command[0] == "FILEWORD":
			label = command[1]
			if label in randomData:
				print("Error: Key already exists")
				exit(1)
			else:
				randomName = randomFiles[command[2]][random.randint(0,len(randomFiles[label])-1)]
				randomName = randomName.rstrip()
				randomData[command[1]] = randomName
				outputFile.write(randomData[command[1]])
		if command[0] == "NUMBER":
			label = command[1]
			minNum = int(command[2])
			maxNum = int(command[3])
			if label in randomData:
				print("Error: Key already exists")
				exit(1)
			else:
				randomNumber = random.randint(minNum,maxNum)
				randomData[command[1]] = str(randomNumber)
				outputFile.write(randomData[command[1]])
		if commandsList[0] == "REFER":
			label = command[1]
			outputFile.write(randomData[label])

# Close output file stream
outputFile.close()

exit(0)
