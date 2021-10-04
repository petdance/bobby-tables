#!/usr/bin/perl -T

use warnings;
use strict;

use Test::More;
use Test::HTML::Tidy5;
use Encode qw(decode_utf8);

my @files = (glob( 'build/*.html' ), glob ( 'build/*/*.html' ));
plan tests => scalar @files;

for my $filename ( @files ) {
    my $text = decode_utf8(
        do {local(@ARGV, $/) = $filename; <>} # slurp file contents
    );

    html_tidy_ok( $text, $filename );
}
