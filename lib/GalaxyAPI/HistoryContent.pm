package GalaxyAPI::HistoryContent;

use strict;
use warnings;

use GalaxyAPI::Utils::Arguments qw{rearrange};
use base qw{GalaxyAPI::BaseObject};

sub new {
    my $pkg  = shift;
    my $self = $pkg->SUPER::new( @_ );

    return $self;
}

sub type :lvalue { $_[0]->{'type'}; }

sub _extra_json_keys {
    return qw(type);
}


1;
