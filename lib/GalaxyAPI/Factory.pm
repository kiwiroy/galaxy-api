package GalaxyAPI::Factory;

use strict;
use warnings;

use URI;
use JSON::XS;
use Data::Dumper;

sub new {
    my $pkg = shift;
    my $self = bless {}, $pkg;
    return $self;
}

sub run {
    my ($self, $api, $path, $body, $header) = @_;
    my @objects;
    my $uri      = $self->_make_path( $path || [] );
    my $method   = $self->method( $body ) || 'get';
    my $json     = $self->_make_json( $body );
    my $response = $api->request($method, $uri, $json, $header );

    if ($response->is_success) {
	push @objects, @{ $self->produce( $response ) };
    }

    return \@objects;
}

sub method {
    my ($self, $data, $method) = @_;
    unless($data && ref($data)) {
	$method = 'get';
    }
    return $method;
}

sub produce {
    my ($self, $response) = @_;
    my $data = decode_json( $response->content );
    ## TODO: JSON error handling etc... (objectify)
    $self->_records_from_decoded_json( ref($data) eq 'ARRAY' ? $data : [ $data ] );
}

sub _make_json {
    my ($self, $data, $json) = @_;

    if ($data) {
	my @json_data;
	foreach my $input(@{ ref($data) eq 'ARRAY' ? $data : [ $data ] }) {
	    push @json_data, $self->_json_data_from_object( $input );
	}
	if (@json_data) {
	    $json = encode_json( @json_data == 1 ? $json_data[0] : \@json_data );
	}
	warn " ** $json \n";
    }

    return $json;
}

sub _json_data_from_object {
    my ($self, $object) = @_;

    my $json_data = { map  { $_ => $object->{$_}   } 
		      grep { defined $object->{$_} } $object->_json_keys };
    
    return $json_data;
}

sub _make_path {
    my ($self, $path) = @_;
    my $base = $self->base;
    my $qury = '';

    if (@$path) {
	$path->[0] eq $base or do {
	    unshift @$path, $base;
	};
    } else {
	push @$path, $base;
    }

    if (ref($path->[-1]) eq 'HASH') {
	my $uri = URI->new();
	my $q   = pop @$path;
	$qury   = $uri->query_form( %$q )->as_string();
    }
    
    my $newpath = join('', join('/', '', @$path), $qury);
    return $newpath;
}

1;

__END__
