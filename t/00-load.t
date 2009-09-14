#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'KiokuDB::Backend::Redis' );
}

diag( "Testing KiokuDB::Backend::Redis $KiokuDB::Backend::Redis::VERSION, Perl $], $^X" );
