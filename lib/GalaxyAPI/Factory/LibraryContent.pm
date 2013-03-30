package GalaxyAPI::Factory::LibraryContent;

use strict;
use warnings;

use GalaxyAPI::LibraryContent;

use base qw{GalaxyAPI::Factory::Library};

sub _records_from_decoded_json {
    my ($self, $data) = @_;
    my @records;
    foreach my $entry(@$data){
	my $library = GalaxyAPI::LibraryContent->new_from_hash( $entry );
#	$library->id or do {
#	    ## fill in this information - makes some _big_ assumptions
#	    my @parts     = split '/', $library->contents_url;
#	    $library->id  = $parts[-2];
#	    $library->url = join '/', @parts[0..($#parts-1)];
#	};
	push @records, $library;
    }
    return \@records;
}

1;
