#!/bin/bash

# Checking that a file path was passed
if [ -z $1 ]
then
    echo "Usage: srpt /path/to/file"
    exit 1
fi

# Finding everything at specified location
find $1 \( -type f -fprintf /tmp/AMSfCount "\n" \) , \( -type d -fprintf /tmp/AMSdCount "\n" \) , \( -type f -size +4096c -fprintf /tmp/AMSlfCount "%s\n" \) , \( -type f -mtime +365 -fprintf /tmp/AMSoldFiles "\n" \) , \( -type f -name "*.jpg" -o -name "*.gif" -o -name "*.bmp" -fprintf /tmp/AMSiCount "\n" \) , \( -type f -name "*.o" -fprintf /tmp/AMSoCount "\n" \) , \( -type f -executable -fprintf /tmp/AMSeCount "\n" \) , \( -type l -fprintf /tmp/AMSsCount "\n" \)

# Counting and formatting files found

# All directories
dirCount=$(wc -l /tmp/AMSdCount | cut -d" " -f1)
let "dirCount-=1"

# All files
fileCount=$(wc -l /tmp/AMSfCount | cut -d" " -f1)
fileCount=$(printf "%'d\n" $fileCount)

# Old files
oldFileCount=$(wc -l /tmp/AMSoldFiles | cut -d" " -f1)
oldFileCount=$(printf "%'d\n" $oldFileCount)

# Large files
largeFileCount=$(wc -l /tmp/AMSlfCount | cut -d" " -f1)
largeFileCount=$(printf "%'d\n" $largeFileCount)

# Image files
imageFileCount=$(wc -l /tmp/AMSiCount | cut -d" " -f1)
imageFileCount=$(printf "%'d\n" $imageFileCount)

# Temporary files
tempFileCount=$(wc -l /tmp/AMSoCount | cut -d" " -f1)
tempFileCount=$(printf "%'d\n" $tempFileCount)

# Executable files
execFileCount=$(wc -l /tmp/AMSeCount | cut -d" " -f1)
execFileCount=$(printf "%'d\n" $execFileCount)

# Symlink files
symFileCount=$(wc -l /tmp/AMSsCount | cut -d" " -f1)
symFileCount=$(printf "%'d\n" $symFileCount)

# Total file size
#totalFileSize=$(awk '{ sum += $1 } END { print sum }'"tmp/fsize")
#totalFileSize=$(printf "%'d\n" $totalFileSize)

# Printing all organized information
echo SearchReport $HOSTNAME $1 `date` "\n"Execution time $SECONDS "\n"Directories $dirCount "\n"Files $fileCount "\n"Sym links $symFileCount "\n"Old files $oldFileCount "\n"Large files $largeFileCount "\n"Graphics files $imageFileCount "\n"Temporary files $tempFileCount "\n"Executable files $execFileCount "\n"TotalFileSize #$totalFileSize

exit 0
