#!/usr/bin/perl
use Test::More;
use Test::TempDir;

unless(defined($ENV{KIOKU_REDIS_URL})) {
    plan skip_all => 'Must set KIOKU_REDIS_URL environment variable';
}

use ok 'KiokuDB';
use ok 'KiokuDB::Backend::Redis';

use KiokuDB::Test;

for $fmt ( qw(storable json), eval { require YAML::XS; "yaml" } ) {
    run_all_fixtures(
        KiokuDB->connect("Redis:server=127.0.0.1:6379", serializer => $fmt, create => 1),
    );
}

done_testing;