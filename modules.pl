#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

my @modules = qw(
    Encode
    File::Slurp
    Getopt::Long
    Markdent
    Template
    Test::HTML::Tidy5
);

say '# Checking that we have all our necessary modules.';
for my $module ( @modules ) {
    eval "use $module; 1" or die "Can't load $module";
    my $vername = '$' . ${module} . '::VERSION';
    my $ver = eval $vername;
    say "$module $ver";
}
say '# All modules loaded.';
