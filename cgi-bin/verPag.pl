#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
my $page_id = $cgi->param('id');

# Conexion a la base de datos
my $dsn = "DBI:mysql:database=markdown_db;host=midb;port=3306";
my $db_user = "root";
my $db_password = "1234";

# Crear conexion con la base de datos
my $dbh = DBI->connect($dsn, $db_user, $db_password, {
    RaiseError => 1,
    AutoCommit => 1,
}) or die "No se pudo conectar a la base de datos: $DBI::errstr";
my $sth = $dbh->prepare("SELECT name, content FROM pages WHERE id = ?");
$sth->execute($page_id);
my ($page_name, $content) = $sth->fetchrow_array;

print $cgi->header('text/html');
print "<h1>$page_name</h1>";
print "<pre>$content</pre>";
