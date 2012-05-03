#!/usr/bin/perl -T

use warnings;
use strict;

use Test::More tests => 2;

use File::Slurp;

my $english_index = read_file( 'build/index.html' ) or die;
my $german_index  = read_file( 'build/de_DE/index.html' ) or die;
my $russian_index = read_file( 'build/ru_RU/index.html' ) or die;

my $english_title = get_title( $english_index ) or die;
my $german_title = get_title( $german_index ) or die;
my $russian_title = get_title( $russian_index ) or die;

isnt( $english_title, $german_title, 'German has been translated' );

TODO: {
    local $TODO = 'Russian translations have not been done yet';
    isnt( $english_title, $russian_title, 'Russian has been translated' );
}

done_testing();


sub get_title {
    my $html = shift;

    $html =~ m{<title>(.+)</title>} or die "Can't find a title";

    my $title = $1;

    $title =~ s/\s+$//;
    $title =~ s/^\s+//;

    return $title;
}
