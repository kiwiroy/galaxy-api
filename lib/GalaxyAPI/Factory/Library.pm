package GalaxyAPI::Factory::Library;

use strict;
use warnings;

use GalaxyAPI::Library;

use base qw{GalaxyAPI::Factory};

sub base   { return 'libraries'; }

sub method {
    my ($self, $data, $method) = @_;
    $method = $self->SUPER::method($data);
    return $method if $method;

    if(ref($data) eq 'ARRAY') {
	if(grep { ref($_) eq 'GalaxyAPI::Library'} @$data == @$data) {
	    $method = 'post';
	} else {
	    warn "All members of '$data' must be GalaxyAPI::Library objects\n";
	}
    } elsif(ref($data) eq 'GalaxyAPI::Library') {
	$method = 'post';
    } elsif(ref($data) eq 'GalaxyAPI::LibraryContents') {
	$method = 'post';
    }

    return $method;
}


sub _records_from_decoded_json {
    my ($self, $data) = @_;
    my @records;
    foreach my $entry(@$data){
	my $library = GalaxyAPI::Library->new_from_hash( $entry );
	$library->id or do {
	    ## fill in this information - makes some _big_ assumptions
	    my @parts     = split '/', $library->contents_url;
	    $library->id  = $parts[-2];
	    $library->url = join '/', @parts[0..($#parts-1)];
	};
	push @records, $library;
    }
    return \@records;
}

1;
