# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl GalaxyAPI.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use lib 't/lib';
use Test::More tests => 15;
use TestFunctions qw{_to_json};

BEGIN { 
    use_ok('GalaxyAPI::User');
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.


my $first = GalaxyAPI::User->new();

ok( $first, 'object created' );

my $id    = 'id';
my $name  = 'name';
my $url   = '/url';
my $email = 'email@address.com';

my $second = GalaxyAPI::User->new(-id    => $id,
				  -name  => $name,
				  -url   => $url,
				  -email => $email);

ok( $second );

is( $second->id,    $id,    '->id identity' );

is( $second->name,  $name,  '->name identity' );

is( $second->url,   $url,   '->url identity' );

is( $second->email, $email, '->email identity' );

ok( $second->as_string, 'Stringify object method' );

ok( $second->_json_keys, 'JSON keys');

my $hash  = { id => $id, name => $name, url => $url };

my $third = GalaxyAPI::User->new_from_hash( $hash );

is( $third->id,   $id,   '->id identity (from hash)' );

is( $third->name, $name, '->name identity (from hash)' );

is( $third->url,  $url,  '->url identity (from hash)' );

my $exp_json = _to_json($hash,  $third->_json_keys);
my $got_json = _to_json($third, $third->_json_keys);

is( $got_json, $exp_json, 'JSON content' );

ok( 1 );
ok( 1 );
