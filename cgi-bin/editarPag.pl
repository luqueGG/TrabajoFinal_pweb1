#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
my $page_id = $cgi->param('id') || die "No se proporcionó un ID de página.";

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

    my $sth = $dbh->prepare("UPDATE pages SET name = ?, content = ? WHERE id = ?");
    $sth->execute($page_name, $content, $page_id);

    print $cgi->header('text/html');
    print "<h1>Página actualizada con éxito</h1>";
    print "<a href='/index.html'>Regresar al índice</a>";
} else {
    my $sth = $dbh->prepare("SELECT name, content FROM pages WHERE id = ?");
    $sth->execute($page_id);
    my ($page_name, $content) = $sth->fetchrow_array;

    print $cgi->header('text/html');
    print <<HTML;
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Página</title>
</head>
<body>
    <h1>Editar Página</h1>
    <form method="post">
        Nombre de la página: <input type="text" name="page_name" value="$page_name"><br>
        Contenido (Markdown):<br>
        <textarea name="content" rows="10" cols="50">$content</textarea><br>
        <input type="submit" name="submit" value="Actualizar">
    </form>
    <a href='/index.html'>Cancelar</a>
</body>
</html>
HTML
}

# Cerrar conexión
$dbh->disconnect;
