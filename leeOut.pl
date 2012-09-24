#!/usr/bin/perl 
#===============================================================================
#
#         FILE: main.pl
#
#        USAGE: ./main.pl
#
#  DESCRIPTION: Analizador de potenciales
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Alexis Ibarra (ai), ar.ibarrasalas@gmail.com
# ORGANIZATION: Universidad Simón Bolívar
#      VERSION: Beta 1.0
#      CREATED: 18/08/12 14:03:43
#      REVISED: 18/08/12 14:03:47
#     REVISION: 0
#===============================================================================

use strict;
use warnings;
my %val = &leeOut(@ARGV);
print &ji_c(%val) . "\n";

#
#foreach my $llave ( sort { $a cmp $b } keys %val ) {
#    print $llave . " = " . $val{$llave} . "\n";
#}

sub ji_c {
    my (%valores) = @_;
    my %valOrd;
    my @dat_exp =
      ( 736.39125, 229.93575, 71.14650, 11.86279, 11.37674, 11.19291, 0.72269 );
    my @dat_teo;
    foreach my $llave ( sort { $a cmp $b } keys %valores ) {
        push( @dat_teo, $valores{$llave} );
    }
    my $tam = @dat_teo;
    my $i;
    my $ji_c = 0;
    for ( $i = 0 ; $i < $tam ; $i++ ) {
        $ji_c = $ji_c + ( ( $dat_exp[$i] - $dat_teo[$i] )**2 ) / $dat_teo[$i];
    }
    return $ji_c;
}    ## -- end sub ji_c

sub leeOut {
    my ($filename) = @_;
    open INFILE, $filename;
    my $linea;
    my $format1 = '%f';
    my $format2 = '%.2f';
    my @numeros =
      ( '16.00', '22.00', '28.00', '34.00', '35.00', '39.00', '46.00', );
    my $s_numeros = join( "|", @numeros );
    my %valores;

    while ( $linea = <INFILE> ) {
        if ( $linea =~ /\s+(\d{1,2}\.\d{1,2})\sdeg\.:\sX-S\s=\s+([^\s]*)/ ) {
            my $x = $1;
            my $y = $2;
            if ( $x =~ /$s_numeros/ ) {
                $valores{ sprintf( $format2, $x ) } = sprintf( "%f", $y );
            }
        }
    }
    close INFILE;
    return %valores;
}    ## --- end sub gus
