#!/usr/bin/python

# Import required modules
import sqlite3
import csv
import sys

# Check for 2 arguments passed to the script
if len(sys.argv) != 3:
	print("Usage: dbload CSVFILE DATABASEFILE")
	exit(1)

# Save CSV and database files passed to script
CSVName = sys.argv[1]
dbName = sys.argv[2]

# Set up database connection and cursor
try:
	dbConnection = sqlite3.connect(dbName)
	dbCursor = dbConnection.cursor()
except Exception as thrownError:
	print("Error connecting to database: " + str(thrownError))
	exit(1)

# Drop classes and students tables if they already exists
dbCursor.execute('''DROP TABLE IF EXISTS classes''')
dbCursor.execute('''DROP TABLE IF EXISTS students''')

# Create classes and students tables
dbCursor.execute('''CREATE TABLE classes
	(id text, subjcode text, coursenumber text, termcode text)''')
dbCursor.execute('''CREATE TABLE students
	(id text primary key unique, lastname text, firstname text, major text, email text, city text, state text, zip text)''')

# Open CSV file
try:
	CSVReader = csv.reader(open(CSVName, 'r'), delimiter=',', quotechar='"')
except Exception as thrownError:
	print("Error opening input file: " + str(thrownError))
	exit(1)

# Function to test if W# already exists in database
def checkWNum(wNumber):
	dbCursor.execute("SELECT * FROM students WHERE id = ?", (wNumber,))
	idExists = dbCursor.fetchone()

	if idExists is not None:
		return True
	else:
		return False

# Create counter to keep track of rows
rowCounter = 0

# Read rows in CSV file
for row in CSVReader:
	
	# Used to skip first row which is a header
	rowCounter += 1
	
	if rowCounter == 1:
		continue

	# Check if student already exists
	testWNum = str(row[0])
	ifIDExists = checkWNum(testWNum)

	# If student already exists then insert class info only 
	if ifIDExists:
		# Split course into subjcode and coursenumber
		courseSplit = str(row[5])
		course = courseSplit.split(" ")
	
		# Prep class values for class table
		classesValues = (row[0], course[0], course[1], row[6])
	
		# Insert rows into class table
		dbCursor.execute('''INSERT INTO classes (id, subjcode, coursenumber, termcode) VALUES (?, ?, ?, ?)''', classesValues)

	# If student does not exist then insert student and class info
	else:
		# Prep student values for student table
		studentsValues = (row[0], row[2], row[1], row[4], row[3], row[7], row[8], row[9])
		
		# Insert rows into student table
		dbCursor.execute('''INSERT INTO students (id, lastname, firstname, major, email, city, state, zip) VALUES (?, ?, ?, ?, ?, ?, ?, ?)''', studentsValues)

		# Split course into subjcode and coursenumber
		courseSplit = str(row[5])
		course = courseSplit.split(" ")
	
		# Prep class values for class table
		classesValues = (row[0], course[0], course[1], row[6])
	
		# Insert rows into class table
		dbCursor.execute('''INSERT INTO classes (id, subjcode, coursenumber, termcode) VALUES (?, ?, ?, ?)''', classesValues)
	
# Commit changes to database
dbConnection.commit()

# Exit 0 if successful
exit(0)
