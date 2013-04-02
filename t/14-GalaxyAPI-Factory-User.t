# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl GalaxyAPI.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use lib 't/lib';
use Test::More tests => 10;
use TestFunctions qw{_to_json};

BEGIN { 
    use_ok('GalaxyAPI::Factory::User');
    use_ok('GalaxyAPI::User');
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $factory = GalaxyAPI::Factory::User->new();

ok( $factory );

is( $factory->method, 'get', 'default method is "get"' );

my $user = GalaxyAPI::User->new(-id => 'id');

my $exp_json = _to_json($user, $user->_json_keys);

is( $factory->_make_json([ $user ]), $exp_json, 'single json object - no array' );

ok( $factory->records_from_decoded_json([]), 'records_from_decoded_json implemented' );

ok( 1 );
ok( 1 );
ok( 1 );
ok( 1 );
