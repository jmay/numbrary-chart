#!/usr/bin/env perl

use strict;
use File::Basename;
use Getopt::Std;
use POSIX qw(mkfifo);
use File::Temp; # for tempdir
use YAML::Syck qw(Load Dump LoadFile DumpFile);
use Storable; $Storable::canonical = 1; # for runlog hash comparison


my %opts;
getopts("fv", \%opts) or die "usage: test.pl [-f] [tests]";

my $dirname = dirname(__FILE__);
chdir $dirname or die $!;

if (scalar(@ARGV) > 0) {
  for my $testcase (@ARGV) {
    runtest($testcase)
  }
  exit;
}

opendir DIR, "." or die $!;
for my $testcase (readdir DIR) {
  next unless -d $testcase && $testcase !~ /^\./;
#   print $testcase, "\n";
  runtest($testcase);
}
closedir DIR;


sub runtest {
  my ($testcase) = @_;

  # each test case should read the input and spit out the results in YAML
  print "run make-chart < $testcase/input and compare with $testcase/output\n";
}
