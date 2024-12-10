#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
my $page_id = $cgi->param('id') || die "No se proporcionó un ID de pagina.";