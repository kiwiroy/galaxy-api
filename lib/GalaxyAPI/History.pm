package GalaxyAPI::History;

use strict;
use warnings;

use GalaxyAPI::Utils::Arguments qw{rearrange};
use GalaxyAPI::Utils::Scalar qw{uri_array};

use base qw{GalaxyAPI::BaseObject};

sub new {
    my $pkg  = shift;
    my $self = $pkg->SUPER::new( @_ );
    my ($annotation, $contents_url, $nice_size, $state) 
	= rearrange([qw(ANNOTATION CONTENTS_URL NICE_SIZE STATE)], @_);

    $self->annotation   = $annotation   if $annotation;
    $self->contents_url = $contents_url if $contents_url;
    $self->nice_size    = $nice_size    if $nice_size;
    $self->state        = $state        if $state;

    return $self;
}

sub annotation   :lvalue { $_[0]->{'annotation'};   }
sub contents_url :lvalue { $_[0]->{'contents_url'}; }
sub nice_size    :lvalue { $_[0]->{'nice_size'};    }
sub state        :lvalue { $_[0]->{'state'};        }

sub contents {
    my ($self, $contents) = @_;

    if (check_ref($contents, 'ARRAY') &&
	scalar(@$contents) > 0        &&
	check_ref($contents->[0], 'GalaxyAPI::HistoryContent' )) {
	$self->{'contents'} = $contents;
    }

    return $self->{'contents'};
}

sub state_details {
    my $self = shift;
    return $self->{'state_details'};
}

sub state_ids {
    my $self = shift;
    return $self->{'state_ids'};
}

sub state_by_id {
    my ($self, $id) = @_;
    my $retval = 'unknown';
    foreach my $state(keys %{$self->{'state_ids'}}) {
	my $ids = $self->{'state_ids'}{$state};
	if(grep { $_ eq $id } @$ids){
	    $retval = $state;
	    last;
	}
    }
    return $retval;
}

sub _extra_json_keys {
    return qw(contents_url annotation state nice_size);
}


1;
