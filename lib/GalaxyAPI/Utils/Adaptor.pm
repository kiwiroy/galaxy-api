package GalaxyAPI::Utils::Adaptor;

use strict;
use warnings;

use GalaxyAPI::Utils::Arguments qw{rearrange};

sub new {
    my $pkg  = shift;
    my ($api, $factory) = rearrange([qw(API FACTORY)], @_);
    my $self = bless [ $api, $factory ], $pkg;
    return $self;
}

sub api     { return $_[0]->[0]; }
sub factory { return $_[0]->[1]; }

sub populate {
    my ($self, $object, $recurse) = @_;
    $self->factory->populate($self->api, $object, $recurse);
}

1;
