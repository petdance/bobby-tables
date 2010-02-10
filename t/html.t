#!/usr/bin/perl -w

use warnings;
use strict;

use Test::More;
use Test::HTML::Lint;
use File::Slurp;

my @files = glob( 'build/*.html' );
plan( tests => scalar @files );

for my $filename ( @files ) {
    my $text = read_file( $filename );

    html_ok( $text, $filename );
}
