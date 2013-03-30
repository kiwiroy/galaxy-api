package GalaxyAPI::Workflow;

use strict;
use warnings;

use base qw{GalaxyAPI::BaseObject};

sub steps  :lvalue { $_[0]->{'steps'};  }
sub inputs :lvalue { $_[0]->{'inputs'}; }

sub _json_keys {
    return qw(id url name steps inputs);
}


1;
