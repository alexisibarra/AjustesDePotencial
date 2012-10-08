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
my %val = &procOut(@ARGV);
print &ji_c(%val) . "\n";

#===  FUNCTION  ================================================================
#         NAME: procOut
#      PURPOSE: Aplicar Ji cuadrado
#   PARAMETERS: Lista de valores
#      RETURNS: Flotante resultado de la evaluación de la función
#     COMMENTS: Para una futura versión fuese bueno que se leyeran los datos
#     			experimentales desde un archivo de configuración
#===============================================================================
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

#===  FUNCTION  ================================================================
#         NAME: procOut
#      PURPOSE: Leer desde el archivo de salida para obtener los valores de 
#      			interés para el cálculo del Ji cuadrado. 
#   PARAMETERS: Dirección del archivo en cuestión
#      RETURNS: Lista de flotantes
#       THROWS: no exceptions
#===============================================================================
sub procOut {
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
