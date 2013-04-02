=pod

=head1 NAME

GalaxyAPI::BaseObject - Base object to inherit from

=head1 DESCRIPTION

=head1 SYNOPSIS

=head1 METHODS

The following methods are available for use and abuse.

=cut

package GalaxyAPI::BaseObject;

use strict;
use warnings;
use Data::Dumper;
use Scalar::Util qw{blessed};
use GalaxyAPI::Utils::Scalar qw{uri_array};
use GalaxyAPI::Utils::Arguments qw{rearrange};

=head2 new

 -id
 -name
 -url

=cut

sub new {
    my $pkg  = shift;
    my ($id, $name, $url) = rearrange([qw(ID NAME URL)], @_);

    my $self = bless {
	id   => $id,
	name => $name,
	url  => $url,
    }, ref($pkg) || $pkg;

    return $self;
}

sub new_from_json {
    die "not implemented";
}

=head2 new_from_hash

=cut

sub new_from_hash {
    my $pkg  = shift;
    my $self = bless $_[0], ref($pkg) || $pkg;
    return $self;
}

=head2 augment_from_hash

=cut

sub augment_from_hash {
    my ($self, $hash) = @_;
    if (blessed $self) {
	## direct copy - overwritting whatever is in $self ...
	if (exists($hash->{'id'}) && $self->id eq $hash->{'id'}) {
	    map { $self->{ $_ } = $hash->{$_} } keys %$hash;
	} elsif (exists($hash->{'name'}) && $self->name eq $hash->{'name'}) {
	    map { $self->{ $_ } = $hash->{$_} } keys %$hash;
	} else {
	    warn sprintf("Augment failed! %s (%s != %s)\n", $self->name, $self->id, $hash->{'id'});
	}
    } else {
	$self = shift->new_from_hash( $hash );
    }
    return $self;
}

=head2 id

=head2 url

=head2 name

=cut

sub id      :lvalue { $_[0]->{'id'};      }
sub url     :lvalue { $_[0]->{'url'};     }
sub name    :lvalue { $_[0]->{'name'};    }
sub adaptor :lvalue { $_[0]->{'adaptor'}; }

=head2 _json_keys

=cut

sub _json_keys {
    my $self = shift;
    return (qw{id url name}, $self->_extra_json_keys);
}

sub _extra_json_keys { return (); }

=head2 require_detail

=cut

sub require_detail {
    my $self = shift;
    return scalar(grep { ! defined $_ } @$self{ $self->_extra_json_keys });
}

sub fully_populate {
    my $self = shift;
    if ($self->require_detail){
	$self->adaptor->populate( $self );
    }
    return $self;
}

=head2 detail_uri

=cut

sub detail_uri {
    my $self = shift;
    return uri_array( $self->url );
}

=head2 as_string

=cut

sub as_string {
    my $self = shift;
    my $name = (split('::', ref($self)))[-1] . ':';
    return join(' ', $name,
		map  { "'$_'"  }
		grep { defined } @$self{ $self->_json_keys });
}

sub dumper {
    my $self = shift;
    local $Data::Dumper::Sortkeys = sub {
	my ($hash) = @_;
	return [ sort { $a cmp $b }
		 grep { $_ ne 'adaptor' } keys %$hash ];
    };
    return Dumper $self;
}

1;
