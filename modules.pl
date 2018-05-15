#!/usr/bin/perl

use strict;
use warnings;

my @modules = qw(
    Encode
    File::Slurp
    Getopt::Long
    Template
    Test::HTML::Tidy5
    Text::Markdown
);

print "# Checking that we have all our necessary modules.\n";
for my $module ( @modules ) {
    eval "use $module; 1" or die "Can't load $module";
    my $vername = '$' . ${module} . '::VERSION';
    my $ver = eval $vername;
    print "$module $ver\n";
}
print "# All modules loaded.\n\n";
