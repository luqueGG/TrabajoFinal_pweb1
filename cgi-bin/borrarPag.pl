#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
my $page_id = $cgi->param('id') || die "No se proporcionó un ID de pagina.";
my $dsn = "DBI:mysql:database=markdown_db;host=midb;port=3306";
my $db_user = "root";
my $db_password = "1234";

my $dbh = DBI->connect($dsn, $db_user, $db_password, {
    RaiseError => 1,
    AutoCommit => 1,
}) or die "No se pudo conectar a la base de datos: $DBI::errstr";
