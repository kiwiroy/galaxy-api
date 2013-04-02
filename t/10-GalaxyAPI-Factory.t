# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl GalaxyAPI.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use lib 't/lib';
use Test::More tests => 10;
use TestFunctions qw{_to_json};

BEGIN { 
    use_ok('GalaxyAPI::Factory');
    use_ok('GalaxyAPI::Workflow');
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $factory = GalaxyAPI::Factory->new();

ok( $factory );

is( $factory->method, 'get', 'default method is "get"' );

my $workflow = GalaxyAPI::Workflow->new(-id => 'id');

my $exp_json = _to_json($workflow, $workflow->_json_keys);

is( $factory->_make_json([ $workflow ]), $exp_json, 'single json object - no array' );

is( $factory->_make_json([ $workflow, $workflow ]), "[$exp_json,$exp_json]", 'json array' );

ok( 1 );
ok( 1 );
ok( 1 );
ok( 1 );
