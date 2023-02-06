#!/bin/bash

# Make sure a file was passed
if [ -z $1 ]
then
	echo "Usage: flog LOGFILE"
	exit 1
fi

# Find all userids for failed logins in LOGFILE
sed -n 's/.*Failed password for \([a-z0-9A-Z_]*\) .*/\1/p' $1 >s2out

# Sort all userids in ascending order
sort <s2out >s3out

# Count all unique userids
uniq -c <s3out >s4out

# Sort numeric descending, alpha ascending
sort -k1,1nr -k2,2 s4out >s5out

# Replace "invalid" with "<UNKNOWN>"
sed 's/invalid/\&lt;UNKNOWN\&gt;/' <s5out >s6out

# Place comma in large numbers
if [ -f s7out ] ; then
    rm s7out
fi
cat s6out| while read mycount myuserid; do
	printf "%'d %s\n" "$mycount" "$myuserid" >>s7out
done

# Output file with header/html tags
echo "<html>
<body><h1>Failed Login Attempts Report as of `date`</h1>"
sed 's|^|<br />\t|' s7out
echo "</body></html>"

exit 0
