package GalaxyAPI::Library;

use strict;
use warnings;

use GalaxyAPI::LibraryContent;
use GalaxyAPI::Utils::Arguments qw{rearrange};
use GalaxyAPI::Utils::Scalar    qw{uri_array check_ref};

use base qw{GalaxyAPI::BaseObject};

sub new {
    my $pkg  = shift;
    my $self = $pkg->SUPER::new(@_);
    my ($synopsis, $description, $contents_url) = 
	rearrange([qw(SYNOPSIS DESCRIPTION CONTENTS_URL)], @_);

    $self->synopsis     = $synopsis     if $synopsis;
    $self->description  = $description  if $description;
    $self->contents_url = $contents_url if $contents_url;

    return $self;
}

sub synopsis     :lvalue { $_[0]->{'synopsis'};     }
sub description  :lvalue { $_[0]->{'description'};  }
sub contents_url :lvalue { $_[0]->{'contents_url'}; }

sub contents {
    my ($self, $contents) = @_;

    if (check_ref($contents, 'ARRAY') &&
	scalar(@$contents) > 0        &&
	check_ref($contents->[0], 'GalaxyAPI::LibraryContent' )) {
	$self->{'contents'} = $contents;
    }

    return $self->{'contents'};
}

sub _extra_json_keys {
    return qw(contents_url synopsis description);
}

1;
