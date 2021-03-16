#!/usr/bin/perl

use strict;
use warnings;
use IO::Socket;

if($#ARGV != 1){
	print STDERR "Usage: Not enough parameters provided\n";
	exit(1);
}

my $remote = IO::Socket::INET->new(
	Proto => "tcp",
	PeerAddr => "$ARGV[0]",
	PeerPort => "$ARGV[1]", )
	or die "Cannot connect to port at host";

my $line = <$remote>;
print $line;

exit(0);
