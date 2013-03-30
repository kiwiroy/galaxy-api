package GalaxyAPI::Factory::Workflow;

use strict;
use warnings;

use Data::Dumper;

use GalaxyAPI::Workflow;

use base qw{GalaxyAPI::Factory};

sub base   { return 'workflows'; }

sub method {
    my ($self, $data, $method) = @_;
    $method = $self->SUPER::method($data);
    return $method if $method;

    if(ref($data) eq 'ARRAY') {
	if(grep { ref($_) eq 'GalaxyAPI::Workflow'} @$data == @$data) {
	    $method = 'post';
	} else {
	    warn "All members of '$data' must be GalaxyAPI::Workflow objects\n";
	}
    } elsif(ref($data) eq 'GalaxyAPI::Workflow') {
	$method = 'post';
    }

    return $method;
}


sub _records_from_decoded_json {
    my ($self, $decoded) = @_;
    my @records;
    foreach my $entry(@$decoded) {
	push @records, GalaxyAPI::Workflow->new_from_hash( $entry );
    }
    return \@records;
}


1;
