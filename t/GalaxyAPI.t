# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl GalaxyAPI.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 5;
use Data::Dumper;

BEGIN { 
    use_ok('GalaxyAPI');
    use_ok('GalaxyAPI::Library');
    use_ok('GalaxyAPI::LibraryContents');
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $api = GalaxyAPI->new(-api     => 'http://galaxy-test.pfr.co.nz/api',
			 -api_key => 'fff137f5fda92d809b86b5ed5b9fdc78',
			 -debug   => 0);

$api->username = 'galaxy-admin';
$api->password ( 'galaxy-admin' );
warn "\n";
diag $api->get('/workflows') , "\n";

my $id;
foreach my $workflow (@{ $api->workflows() }) {
    diag $workflow->as_string;
    $id = $workflow->id;
}

my ($workflow) = @{ $api->workflows([ $id ]) };

diag $workflow->as_string;

foreach my $library (@{ $api->libraries() }) {
    diag $library->as_string;
    $id = $library->id;
}

my ($library) = @{ $api->libraries([ $id ]) };

diag $library->as_string;

my ($new_library) = @{ $api->libraries([], GalaxyAPI::Library->new(-name => 'HRARDS')) };

diag $new_library->as_string;

my $content = GalaxyAPI::LibraryContents->new
    (
     -folder_id        => '',
     -file_type        => 'auto',
     -dbkey            => '',
     -upload_option    => 'upload_paths',
     -filesystem_paths => '',
     -create_type      => 'file',
     );

foreach my $contents (@{ $api->library_contents([ $new_library->id ]) }) {
    diag $contents->as_string;
}

warn Dumper $api->libraries([ $new_library->id, 'contents' ], $content);

ok(1);
ok(1);
