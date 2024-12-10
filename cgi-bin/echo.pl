#!/usr/bin/perl

# Echo: creara las paginas
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;

my $dsn = "DBI:mysql:database=markdown_db;host=midb;port=3306";
my $db_user = "root";
my $db_password = "1234";

my $dbh = DBI->connect($dsn, $db_user, $db_password, {
    RaiseError => 1,
    AutoCommit => 1,
}) or die "No se pudo conectar a la base de datos: $DBI::errstr";
if ($cgi->param('submit')) {
    my $page_name = $cgi->param('page_name');
    my $content = $cgi->param('content');

    # Insertar los datos en la base de datos
    my $sth = $dbh->prepare("INSERT INTO pages (name, content) VALUES (?, ?)");
    $sth->execute($page_name, $content);

    print $cgi->header('text/html');
    print "<h1>Pagina creada con exito</h1>";
    print "<a href='/index.html'>Regresar al indice</a>";
}
$dbh->disconnect;