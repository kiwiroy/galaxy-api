package GalaxyAPI::Workflow;

use strict;
use warnings;

use GalaxyAPI::Utils::Arguments qw{rearrange};
use base qw{GalaxyAPI::BaseObject};

sub new {
    my $pkg  = shift;
    my $self = $pkg->SUPER::new( @_ );
    my ($steps, $inputs) = rearrange([qw(STEPS INPUTS)], @_);

    $self->steps  = $steps  if $steps;
    $self->inputs = $inputs if $inputs;

    return $self;
}

sub steps  :lvalue { $_[0]->{'steps'};  }
sub inputs :lvalue { $_[0]->{'inputs'}; }

sub _extra_json_keys {
    return qw(steps inputs);
}

1;
