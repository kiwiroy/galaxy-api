# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl GalaxyAPI.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use lib 't/lib';
use Test::More tests => 15;
use TestFunctions qw{_to_json};

BEGIN { 
    use_ok('GalaxyAPI::LibraryContent');
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.


my $first = GalaxyAPI::LibraryContent->new();

ok( $first, 'object created' );

my $id        = 'id';
my $name      = 'name';
my $url       = '/url';
my $folder_id = $id;
my $file_type = 'auto';
my $dbkey     = 'dbkey';
my $upload_option    = 'upload';
my $filesystem_paths = '/';
my $create_type      = 'create';

my $second = GalaxyAPI::LibraryContent
    ->new(-id        => $id,
	  -name      => $name,
	  -url       => $url,
	  -folder_id => $folder_id,
	  -file_type => $file_type,
	  -dbkey     => $dbkey,
	  -upload_option    => $upload_option,
	  -filesystem_paths => $filesystem_paths,
	  -create_type      => $create_type,
	  );

is( $second->id,  $id,    '->id identity' );

is( $second->url, $url,   '->url identity' );

is( $second->name, $name, '->name identity' );

is( $second->folder_id, $folder_id, '->folder_id identity' );

is( $second->file_type, $file_type, '->file_type identity' );

is( $second->dbkey,     $dbkey,     '->dbkey identity' );

is( $second->upload_option,    $upload_option,    '->upload_option identity' );

is( $second->filesystem_paths, $filesystem_paths, '->filesystem_paths identity' );

is( $second->create_type,      $create_type,      '->create_type identity' );

ok(1);
ok(1);
ok(1);
ok(1);
