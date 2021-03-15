#!/usr/bin/perl

use strict;
use warnings;

if($#ARGV != 1){
	print STDERR "Usage: Not enough parameters provided\n";
	exit(1);
}

while(<STDIN>){
	s/$ARGV[0]/eval qq("$ARGV[1]")/ge;
	print;	
}

exit(0);
