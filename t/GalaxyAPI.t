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

#my ($library) = @{ $api->libraries([ $id ]) };

#diag $library->as_string;

#my ($new_library) = @{ $api->libraries([], GalaxyAPI::Library->new(-name => 'HRARDS')) };

#diag $new_library->as_string;

# my $content = GalaxyAPI::LibraryContents->new
#     (
#      -folder_id        => '',
#      -file_type        => 'auto',
#      -dbkey            => '',
#      -upload_option    => 'upload_paths',
#      -filesystem_paths => '',
#      -create_type      => 'file',
#      );

# foreach my $contents (@{ $api->library_contents([ $new_library->id ]) }) {
#     diag $contents->as_string;
# }

# warn Dumper $api->libraries([ $new_library->id, 'contents' ], $content);

ok(1);
ok(1);
