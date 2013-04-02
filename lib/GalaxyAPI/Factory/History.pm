package GalaxyAPI::Factory::History;

use strict;
use warnings;

use GalaxyAPI::History;

use GalaxyAPI::Utils::Scalar qw{check_ref};
use base qw{GalaxyAPI::Factory};

my $type_G = 'GalaxyAPI::History';

sub base   { return 'histories'; }

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
    }

    return $method;
}


sub records_from_decoded_json {
    my ($self, $data, $adaptor) = @_;
    my @records;
    foreach my $entry(@$data){
	my $history       = GalaxyAPI::History->new_from_hash( $entry );
	$history->adaptor = $adaptor;
	push @records, $history;
    }
    return \@records;
}

1;
