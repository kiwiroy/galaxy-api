package GalaxyAPI::Factory::Library;

use strict;
use warnings;

use GalaxyAPI::Library;
use GalaxyAPI::Utils::Scalar qw{check_ref};

use base qw{GalaxyAPI::Factory};

my $type_G = 'GalaxyAPI::Library';

sub base   { return 'libraries'; }

sub method {
    my ($self, $data, $method) = @_;
    $method = $self->SUPER::method($data);
    return $method if $method;

    if(check_ref($data, 'ARRAY')) {
	if(grep { check_ref($_, $type_G) } @$data == @$data) {
	    $method = 'post';
	} else {
	    warn "All members of '$data' must be $type_G objects\n";
	}
    } elsif(check_ref($data, $type_G)) {
	$method = 'post';
    } elsif(check_ref($data, 'GalaxyAPI::LibraryContents')) {
	$method = 'post';
    }

    return $method;
}

sub content_factory {
    my ($self, $api) = @_;
    return $api->factory('librarycontent');
}

sub records_from_decoded_json {
    my ($self, $data, $adaptor) = @_;
    my @records;
    foreach my $entry(@$data){
	my $library       = GalaxyAPI::Library->new_from_hash( $entry );
	$library->adaptor = $adaptor;
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
