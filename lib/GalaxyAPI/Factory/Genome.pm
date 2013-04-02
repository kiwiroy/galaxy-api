package GalaxyAPI::Factory::Genome;

use strict;
use warnings;

use Data::Dumper;

use GalaxyAPI::Utils::Scalar qw{check_ref};
use GalaxyAPI::Genome;

use base qw{GalaxyAPI::Factory};

my $type_G = 'GalaxyAPI::Genome';

sub base   { return 'workflows'; }

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
    my ($self, $decoded, $adaptor) = @_;
    my @records;
    foreach my $entry(@$decoded) {
	my $object       = GalaxyAPI::Genome->new_from_hash( $entry );
	$object->adaptor = $adaptor;
	push @records, $object;
    }
    return \@records;
}


1;
