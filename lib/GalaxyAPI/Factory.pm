=pod

=head1 NAME

GalaxyAPI::Factory - A base factory object and interface

=head1 DESCRIPTION

=head1 SYNOPSIS

 my $api     = GalaxyAPI->new();
 my $factory = GalaxyAPI::Factory->new();
 $factory->run( $api );

=cut

package GalaxyAPI::Factory;

use strict;
use warnings;

use URI;
use JSON;
use Data::Dumper;

use GalaxyAPI::Utils::Adaptor;
use GalaxyAPI::Utils::Scalar qw{check_ref ensure_array uri_array};

sub new {
    my $pkg = shift;
    my $self = bless { j => JSON::XS->new() }, $pkg;
    return $self;
}

sub base { 
    die join(' - ', "interface method (base)", 
	     ref($_[0]), "does not implement\n");
}

sub records_from_decoded_json {
    die join(' - ', "interface method (records_from_decoded_json)",
	     ref($_[0]), "does not implement\n");
}

sub j { $_[0]->{'j'}; }

sub run {
    my ($self, $api, $path, $body, $header) = @_;
    my @objects;
    my $uri      = $self->_make_path( $path || [] );
    my $method   = $self->method( $body ) || 'get';
    my $json     = $self->_make_json( $body );
    my $response = $api->request($method, $uri, $json, $header );

    if ($response->is_success) {
	my $adaptor = GalaxyAPI::Utils::Adaptor->new(-api     => $api,
						     -factory => $self);
	push @objects, @{ $self->produce( $response, $adaptor ) };
    }

    return \@objects;
}

sub populate {
    $_[0]->fully_populate( $_[1], $_[2], 1 );
}

## this ia a GET only operation
sub fully_populate {
    my ($self, $api, $input, $recurse) = @_;

    foreach my $obj(@{ ensure_array( $input ) }) {
	if ($obj->require_detail) {
	    my $detail   = $obj->detail_uri();
	    my $response = $api->request( 'get', $self->_make_path($detail) );
	    if($response->is_success) {
		my $data     = $self->j->decode( $response->content );
		$obj->augment_from_hash( $data );
	    }
	}

	my $content_factory = $self->content_factory( $api );
	if ($content_factory) {
	    my $contents = $content_factory->run( $api, uri_array( $obj->contents_url ) );
	    $content_factory->fully_populate($api, $contents) if $recurse;
	    $obj->contents( $contents );
	}
    }
    return $input;
}

sub content_factory { return undef; }

sub method {
    my ($self, $data, $method) = @_;
    unless($data && ref($data)) {
	$method = 'get';
    }
    return $method;
}

sub produce {
    my ($self, $response, $adaptor) = @_;
    my $data = $self->j->decode( $response->content );
    ## TODO: JSON error handling etc...
    return $self->records_from_decoded_json( ensure_array($data), $adaptor );
}

sub _make_json {
    my ($self, $data, $json) = @_;

    if ($data) {
	my @json_data;
	foreach my $input(@{ ensure_array($data) }) {
	    push @json_data, $self->_json_data_from_object( $input );
	}
	if (@json_data) {
	    $json = $self->j->encode( @json_data == 1 ? $json_data[0] : \@json_data );
	}
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

    if (check_ref($path->[-1], 'HASH')) {
	my $uri = URI->new();
	my $q   = pop @$path;
	$qury   = $uri->query_form( %$q )->as_string();
    }
    
    my $newpath = join('', join('/', '', @$path), $qury);
    return $newpath;
}

1;

__END__
