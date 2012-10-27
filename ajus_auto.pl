#!/usr/bin/perl 
#===============================================================================
#
#         FILE: ajus_auto.pl
#
#        USAGE: ./ajus_auto.pl <archivo entrada>
#
#  DESCRIPTION:
#
#      OPTIONS: ---
# REQUIREMENTS: Instalación de Fresco
#         BUGS: Un campo puede pasar de 999.9999
#        NOTES: ---
#       AUTHOR: Alexis Ibarra (ai), ar.ibarrasalas@gmail.com
# ORGANIZATION:	Universidad Simón Bolivar
#      VERSION: beta 1.0
#      CREATED: 24/09/12 14:57:18
#	  MODIFIED: 27/10/12 10:42:06
#     REVISION: 3
#===============================================================================

use strict;
use warnings;
use Tie::File;

our $campo;
our $iters;
our $paso;
our ($archivoIn) = @ARGV;
our $archivoOut = $archivoIn;
$archivoOut =~ s/in/out/;

&menu;
&proceso;

#===  FUNCTION  ================================================================
#         NAME: menu
#      PURPOSE: Desplegar menu en pantalla y guardar las elecciones del usuario
#  DESCRIPTION: Muestra tres mensajes por pantalla y establece campo a alterar,
#  				número de iteraciones y el paso de cada iteración.
#===============================================================================
sub menu {
    print("Campo: ");
    $campo = <STDIN>;
    chomp($campo);

    print("Iteraciones: ");
    $iters = <STDIN>;
    chomp($iters);

    print("Paso: ");
    $paso = <STDIN>;
    chomp($paso);
}

#===  FUNCTION  ================================================================
#         NAME: conf
#      PURPOSE: leer el archivo de configuración para establecer las variables
#      			de ejecución según su información.
#       THROWS: no exceptions
#     COMMENTS: no se está usando
#===============================================================================
sub conf {
    open FILE, "<", "conf" or die $!;
    while (<FILE>) {
        if ( $_ =~ /(\d*)\s(\d*)/ ) {
            $iters = $1;
            $paso  = $2;
        }
    }
}

#===  FUNCTION  ================================================================
#         NAME: proceso
#      PURPOSE: Ejecutar las iteraciones de estudio de ji cuadrado
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub proceso {
    my @contenido;
    open( REPORTE,
        ">>doc/reportes/r_c" . $campo . "_p" . $paso . "_i" . $iters . ".rep" )
      || die "No se pudo abrir el archivo";

    tie @contenido, 'Tie::File', $archivoIn
      or die "No se logró hacer el tie: $!";
    my $formato = "(.{8})" x 7;
    my $val;
    for ( 1 .. $iters + 1 ) {
        if ( $contenido[12] =~ /$formato/ ) {
            my @campos = ( $1, $2, $3, $4, $5, $6, $7 );
            $val = substr(
                "   "
                  . sprintf(
                    '%.4f',
                    substr(
                        sprintf( '%.4f',
                            ( $campos[$campo] + ( $paso * ( $_ - 1 ) ) ) ),
                        0, 7
                    )
                  ),
                -8
            );
            if ( $val < 0 || $val > 999.999 ) {
                last;
            }
            print "Ejecutanto iteración $_\n";
            $campos[1] = $val;
            $contenido[12] = join( '', @campos );
        }
        &ejec_fresco;
        print REPORTE $campo . " " 
          . $val . " "
          . &ji_c( &procOut($archivoOut) ) . "\n";
    }
    print "Listo\n";
    close(REPORTE);
    untie @contenido;
}

sub ejec_fresco {
    system( "/usr/local/fresco <" . $archivoIn . "> " . $archivoOut );
}    ## --- end sub ejec_fresco

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

