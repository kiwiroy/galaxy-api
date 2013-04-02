package GalaxyAPI::Factory::User;

use strict;
use warnings;

use GalaxyAPI::User;

use base qw{GalaxyAPI::Factory};

sub base   { return 'users'; }

sub method {
    my ($self, $data, $method) = @_;
    $method = $self->SUPER::method($data);
    return $method if $method;

    if(ref($data) eq 'ARRAY') {
	if(grep { ref($_) eq 'GalaxyAPI::User'} @$data == @$data) {
	    $method = 'post';
	} else {
	    warn "All members of '$data' must be GalaxyAPI::User objects\n";
	}
    } elsif(ref($data) eq 'GalaxyAPI::User') {
	$method = 'post';
    }

    return $method;
}


sub records_from_decoded_json {
    my ($self, $data) = @_;
    my @records;
    foreach my $entry(@$data){
	my $user = GalaxyAPI::User->new_from_hash( $entry );
	push @records, $user;
    }
    return \@records;
}

1;
