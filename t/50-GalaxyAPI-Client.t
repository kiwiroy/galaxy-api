# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl GalaxyAPI.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use lib 't/lib';
use Test::More tests => 20;
use TestFunctions qw{_api_object_from_env};
use Data::Dumper;

BEGIN { 
    use_ok('GalaxyAPI');
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

SKIP: {

    my ($api, $skip) = _api_object_from_env(); 
    my $message      = join('', 'Unset ENV variables require ',
			    '(API_USERNAME API_PASSWORD API_KEY API_URL)');
    my $tests2skip   = 15;
    skip $message, $tests2skip if ($skip);

    diag "working...";

    isnt( $api->host, undef, 'host is not undef' );
    isnt( $api->host, '',    'host is not empty string' );

    isnt( $api->api_key, undef, 'api-key is not undef' );
    isnt( $api->api_key, '',    'api-key is not empty string' );

    isnt( $api->username, undef, 'username is not undef' );
    isnt( $api->username, '',    'username is not empty string' );

    isnt( $api->password, undef, 'password is not undef' );
    isnt( $api->password, '',    'password is not empty string' );
    
    ## 
    like( $api->get('/workflows'), qr/^\[.*\]$/, 'response from valid GET request looks like json');

    ##
    ## Workflows
    ##
    my $workflows = $api->workflows;
    isa_ok( $workflows, 'ARRAY', 'workflows returns ARRAY reference' );

    subtest 'check_workflows' => sub {
	plan tests => ( scalar(@$workflows) * 6);

	my @id_list;

	foreach my $workflow (@$workflows) {
	    isa_ok( $workflow, 'GalaxyAPI::Workflow' );
	    ok( $workflow->as_string, 'as string' );
	    ok( $workflow->id, 'workflow has id' );
	    push @id_list, $workflow->id;
	    diag $workflow->as_string;
	}

	foreach my $id (@id_list) {
	    my ($w) = @{ $api->workflows([ $id ]) };
	    isa_ok( $w, 'GalaxyAPI::Workflow' );
	    is( $w->id, $id, 'ID identity' );
	    ok( $w->as_string );
	    diag $w->as_string;
	}

    } if @$workflows > 0;

    ##
    ## Libraries
    ##
    my $libraries = $api->libraries;
    isa_ok( $libraries, 'ARRAY', 'libraries returns ARRAY reference' );
    subtest 'check_libraries' => sub {
	plan tests => (scalar(@$libraries) * 3);

	foreach my $library (@$libraries) {
	    isa_ok( $library, 'GalaxyAPI::Library' );
	    ok( $library->id, 'library has id' );
	    ok( $library->as_string, 'as string' );
	    diag $library->as_string;
	}
    } if @$libraries > 0;


    ##
    ## Users
    ##
    my $users = $api->users();
    isa_ok( $users, 'ARRAY', 'users returns ARRAY reference' );
    subtest 'check_users' => sub {
	plan tests => (scalar(@$users) * 6);
	
	my @id_list;
	foreach my $user( @$users ) {
	    isa_ok( $user, 'GalaxyAPI::User' );
	    ok( $user->id, 'user has id');
	    ok( $user->email, 'user has email address' );
	    push @id_list, $user->id;
	}

	foreach my $id (@id_list) {
	    my ( $user ) = @{ $api->users([ $id ]) };
	    isa_ok( $user, 'GalaxyAPI::User' );
	    is( $user->id, $id, 'user id identity' );
	    ok( $user->as_string, 'user as_string' );
	    diag $user->as_string;
	}

    } if @$users > 0;

    ##
    ## Histories
    ##
    my $histories = $api->histories();
    isa_ok( $histories, 'ARRAY', 'histories returns ARRAY reference' );
    subtest 'check_histories' => sub {
	plan tests => (scalar(@$histories) * 6);

	my @id_list;
	foreach my $history (@$histories) {
	    isa_ok( $history, 'GalaxyAPI::History' );
	    ok( $history->id, 'history has id' );
	    ok( $history->as_string, 'history as string' );
	    push @id_list, $history->id;
	}

	foreach my $id ( @id_list ) {
	    my ( $history ) = @{ $api->histories([ $id ]) };
	    isa_ok( $history, 'GalaxyAPI::History' );
	    is( $history->id, $id, 'history id identity' );
	    ok( $history->as_string, 'history as_string' );
	    diag $history->as_string;
	}

    } if @$histories > 0;

}

ok( 1 );
ok( 1 );

