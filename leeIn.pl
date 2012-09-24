#!/usr/bin/perl 
#===============================================================================
#
#         FILE: leeIn.pl
#
#        USAGE: ./leeIn.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Alexis Ibarra (ai), ar.ibarrasalas@gmail.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 24/09/12 14:57:18
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use Tie::File;


#Archivo que quieres editar
my ($archivo) = @ARGV;
print $archivo;
#
#
##Definimos el array que vamos a usar
my @contenido;
#
#
##Empieza la magia
tie @contenido, 'Tie::File', $archivo or die "No se logró hacer el tie: $!";
#
#
##Cambiamos la línea 153
## Recuerda que como el array tiene un elemento 0
## la línea 153 realmente es el elemento 152
$contenido[11] = 'Nuevo contenido';
#
#
##Eso es todo...wow! ¡Magia!
untie @contenido;
