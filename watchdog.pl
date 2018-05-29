#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;
use Date::Parse;

our $VERSION = "0.00_00";

sub dosomething {
    my ($pid, $pct) = @_;
    say "PID: $pid";
    printf("cpu was %4.1f%%\n", $pct);
    if ($pct > 30) {
        say "restarting service";
        system('service jackett restart') and warn("restart failed\n");
    }
}

my %plist;
my $match = 'jacket[t]';
my $threshhold = 10;
while (1) {
    print `date`;
    my    @jackett_ps = `ps -ax -o pid,cmd | awk '/$match/ {print \$1}'`;
    chomp @jackett_ps;
    for my $pid (@jackett_ps) {
        my @cputime = `ps -hp $pid -o cputime`;
        chomp @cputime;
        my $cputime = str2time($cputime[0]);
        my ($last_time, $last_cpu);
        if (defined $plist{$pid}) {
            ($last_time, $last_cpu) = @{$plist{$pid}};
        }
        my $now = time();
        $plist{$pid} = [ $now, $cputime ];
        if ($last_time) {
            my $cpu = ($cputime - $last_cpu)/($now - $last_time) * 100;
            dosomething($pid, $cpu) if $cpu > $threshhold;
        }
    }
    sleep 120;
}
