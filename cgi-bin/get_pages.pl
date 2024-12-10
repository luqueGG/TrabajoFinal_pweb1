#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use JSON;

my $cgi = CGI->new;

my $dsn = "DBI:mysql:database=markdown_db;host=midb;port=3306";
my $db_user = "root";
my $db_password = "1234";

my $dbh = DBI->connect($dsn, $db_user, $db_password, {
    RaiseError => 1,
    AutoCommit => 1,
}) or die "No se pudo conectar a la base de datos: $DBI::errstr";

my $sth = $dbh->prepare("SELECT id, name FROM pages");
$sth->execute();

my @pages;
while (my @row = $sth->fetchrow_array) {
    push @pages, { id => $row[0], name => $row[1] };
}
print $cgi->header('application/json');
print encode_json(\@pages);
$sth->finish;
$dbh->disconnect;
