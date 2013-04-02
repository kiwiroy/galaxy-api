package GalaxyAPI::Factory::LibraryContent;

use strict;
use warnings;

use GalaxyAPI::LibraryContent;

use base qw{GalaxyAPI::Factory::Library};

sub records_from_decoded_json {
    my ($self, $data) = @_;
    my @records;
    foreach my $entry(@$data){
	my $library = GalaxyAPI::LibraryContent->new_from_hash( $entry );
	push @records, $library;
    }
    return \@records;
}

sub content_factory { return undef; }

1;
