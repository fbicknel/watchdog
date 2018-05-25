#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;

sub dosomething {
    my ($pid, $pct) = @_;
    say "something done";
    say "PID: $pid";
    say "Activity was $pct %";
}

while (1) {
    print `date`;
    my @jacket_ps = `ps -axu | awk '/mono.*jacket[t]/ {print \$2,\$3}'`;
    chomp @jacket_ps;
    my ($pid, $cpu_pct) = split " ", $jacket_ps[0];
    if ($cpu_pct > 40) {
        say "let's do something...";
        dosomething($pid, $cpu_pct);
    }
    sleep 10;
}
