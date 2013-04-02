# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl GalaxyAPI.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use lib 't/lib';
use Test::More tests => 15;
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

    ##
    ## Workflows
    ##
    my $workflows = $api->workflows;
    isa_ok( $workflows, 'ARRAY', 'workflows returns ARRAY reference' );

    subtest 'check_workflows' => sub {
	plan tests => ( scalar(@$workflows) * 2);

	my @id_list;

	foreach my $workflow (@$workflows) {
	    isa_ok( $workflow, 'GalaxyAPI::Workflow' );
	    ok( $workflow->id, 'workflow has id' );
	    $workflow->fully_populate();
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
	    $library->fully_populate();
	    diag $library->as_string;
	}
    } if @$libraries > 0;

    ##
    ## Users
    ##
    my $users = $api->users();
    isa_ok( $users, 'ARRAY', 'users returns ARRAY reference' );
    subtest 'check_users' => sub {
	plan tests => (scalar(@$users) * 2);
	
	foreach my $user( @$users ) {
	    isa_ok( $user, 'GalaxyAPI::User' );
	    ok( $user->id, 'user has id');
	    $user->fully_populate();
	    diag $user->as_string;
	}
    } if @$users > 0;

    ##
    ## Histories
    ##
    my $histories = $api->histories();
    isa_ok( $histories, 'ARRAY', 'histories returns ARRAY reference' );
    subtest 'check_histories' => sub {
	plan tests => (scalar(@$histories) * 2);

	foreach my $history (@$histories) {
	    isa_ok( $history, 'GalaxyAPI::History' );
	    ok( $history->id, 'history has id' );
	    $history->fully_populate();
	}

    } if @$histories > 0;

    ##
    ## Genomes
    ##
    my $genomes = $api->genomes();
    isa_ok( $genomes, 'ARRAY', 'genomes returns ARRAY reference' );
    subtest 'check_genomes' => sub {
	plan tests => (scalar(@$genomes) * 1);
	
	foreach my $genome (@$genomes) {
	    isa_ok( $genome, 'GalaxyAPI::Genome' );
	    $genome->fully_populate();
	    diag $genome->as_string;
	}
    } if @$genomes > 0;


}

ok( 1 );
ok( 1 );
ok( 1 );
ok( 1 );

