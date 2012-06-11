#!/usr/bin/perl -T

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
# is from XHTML, but it also works this way
$HTML::Lint::HTML4::isKnownAttribute{a}{'xml:lang'} = 1;

my @files = (glob( 'build/*.html' ), glob ( 'build/*/*.html' ));
plan( tests => 2 * @files );

for my $filename ( @files ) {
    my $text = decode_utf8(read_file( $filename ));

    html_ok( $text, $filename );

    # We had a problem where crank.pl was localizing empty strings, which translates to details about localization.
    # This test makes sure that it doesn't happen.
    unlike( $text, qr/POT-Creation-Date/, 'Localization stuff should not leak into HTML' );
}
