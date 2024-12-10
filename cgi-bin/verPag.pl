#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use Text::Markdown 'markdown';

my $cgi = CGI->new;
my $page_id = $cgi->param('id') || die "No se proporcionó un ID de página.";

# Conexión a la base de datos
my $dsn = "DBI:mysql:database=markdown_db;host=midb;port=3306";
my $db_user = "root";
my $db_password = "1234";

# Crear conexión
my $dbh = DBI->connect($dsn, $db_user, $db_password, {
    RaiseError => 1,
    AutoCommit => 1,
}) or die "No se pudo conectar a la base de datos: $DBI::errstr";

# Obtener datos de la página
my $sth = $dbh->prepare("SELECT name, content FROM pages WHERE id = ?");
$sth->execute($page_id);
my ($page_name, $content) = $sth->fetchrow_array;

# Convertir contenido a HTML
my $html_content = markdown($content);

# Mostrar resultado
print $cgi->header('text/html');
print <<HTML;
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$page_name</title>
    <link rel="stylesheet" href="/estilos.css">
</head>
<body>
    <h1>$page_name</h1>
    <div>$html_content</div>
    <a href='/index.html'>Regresar al índice</a>
</body>
</html>
HTML

# Cerrar conexión
$dbh->disconnect;
