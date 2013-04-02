# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl GalaxyAPI.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 15;

BEGIN { 
    use_ok('GalaxyAPI');
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $host = 'galaxy-test.com';
my $user = 'username';
my $pass = 'password';
my $akey = 'acbdef01234567890f';

my $api = GalaxyAPI->new(-api      => "http://$host/api", 
			 -api_key  => $akey,
			 -debug    => 0,
			 -username => $user,
			 -password => $pass,);

ok( $api, 'API galaxy object' );

is( $api->debug, 0, 'debug value corect' );

ok( $api->cookie_jar, 'HTTP::Cookies object got created' );

ok( $api->client, 'A REST::Client got created' );

is( $api->host, "$host:80", "host is $host:80" );

is( $api->username, $user, 'username set correctly' );

is( ref($api->password), 'CODE', 'password returns a sub ref' );

is( $api->password->(), $pass, 'password set correctly' );

is( $api->api_key, $akey, 'API key set correctly' );


my @factories = qw(History HistoryContent
		   Library LibraryContent
		   User    Workflow);

subtest 'check_factory' => sub {
    plan tests => scalar(@factories);

    foreach my $f(@factories) {
	isa_ok( $api->factory( $f ), 'GalaxyAPI::Factory' );
    }
};

ok( 1 );
ok( 1 );
ok( 1 );
ok( 1 );
