#!/usr/bin/perl -w

use warnings;
use strict;

use Test::More;
use Test::HTML::Lint;
use File::Slurp;
use Encode qw(decode_utf8);

{
no warnings 'redefine';
*HTML::Lint::Parser::_text = sub {return};
# http://www.w3.org/International/tutorials/tutorial-char-enc/#Slide0420
}

my @files = glob( 'build/*.html' );
plan( tests => scalar @files );

for my $filename ( @files ) {
    my $text = decode_utf8(read_file( $filename ));

    html_ok( $text, $filename );
}
