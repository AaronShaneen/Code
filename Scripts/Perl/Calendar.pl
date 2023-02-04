#!/usr/bin/perl -T

use 5.010;
use CGI;
use CGI::Carp qw/fatalsToBrowser/;

use strict;
use warnings;

my @months = qw(january february march april may june july august september october november december);

my $q = CGI->new();
say $q->header(), $q->start_html(-title=>'Calendar');

for my $param ($q->param()) {
    my $safe_param = $q->escapeHTML($param);

    for my $value ($q->param($param)) {
		my $params = $q->escapeHTML($value);
		{
			local $ENV{"PATH"} = "/bin:/usr/local/bin:/usr/bin";
			local $ENV{"BASH_ENV"}="";
			my $date = "";

			# If $params is empty or all white space, set $date to a single space
			# If $params is only a single 1-4 digit year, set $date to year
			# If $params is a 1-2 digit month and a 1-4 digit year set $date to month and year
			# If $params is a 3 or more alpha char month and a 1-4 digit year, set $date to month and year

			if  ($date eq "") {
				say "<h1>Invalid Parameters: $params</h1>";
			} else {
				say "<h1>Parameters: $params</h1>";
			}
			my $cmds = "cal -h " . $date;
			my @lines = `$cmds`;
			say ("<pre>");
			for my $line (@lines) {
				print ("$line");
			}
			say ("</pre>");
		}
    }
    say '</p>';
}

say $q->end_html();
