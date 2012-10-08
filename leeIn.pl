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

my ($archivo) = @ARGV;
my @contenido;
tie @contenido, 'Tie::File', $archivo or die "No se logró hacer el tie: $!";
my $formato = "(.{8})" x 7;
print $formato;
if ($contenido[12] =~ s/$formato/$1$2+1/g){
	print  $1;
}

#if ( $contenido[12] =~ /\s{2}\d\s\d*\s\d+(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})/ ) {
#	my $hola = $6 + 13;
#    print "Tu número es: " . $hola . "\n";
#}
## la línea 153 realmente es el elemento 152
#$contenido[12] = 'Nuevo contenido';
##Eso es todo...wow! ¡Magia!
untie @contenido;
