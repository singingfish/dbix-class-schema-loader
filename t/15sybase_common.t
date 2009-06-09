use strict;
use lib qw(t/lib);
use dbixcsl_common_tests;

my $dsn      = $ENV{DBICTEST_SYBASE_DSN} || '';
my $user     = $ENV{DBICTEST_SYBASE_USER} || '';
my $password = $ENV{DBICTEST_SYBASE_PASS} || '';

my $tester = dbixcsl_common_tests->new(
    vendor      => 'Sybase',
    quote_char  => [qw/[ ]/],
    auto_inc_pk => 'INTEGER IDENTITY NOT NULL PRIMARY KEY',
    dsn         => $dsn,
    user        => $user,
    password    => $password,
);

if( !$dsn || !$user ) {
    $tester->skip_tests('You need to set the DBICTEST_SYBASE_DSN, _USER, and _PASS environment variables');
}
else {
    $tester->run_tests();
}