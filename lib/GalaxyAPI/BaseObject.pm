package GalaxyAPI::BaseObject;

use strict;
use warnings;

use GalaxyAPI::Utils::Arguments qw{rearrange};

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
sub new_from_hash {
    my $pkg  = shift;
    my $self = bless $_[0], ref($pkg) || $pkg;
    return $self;
}

sub id     :lvalue { $_[0]->{'id'};   }
sub url    :lvalue { $_[0]->{'url'};  }
sub name   :lvalue { $_[0]->{'name'}; }

sub _json_keys {
    return qw{id url name};
}

sub as_string {
    my $self = shift;
    my $name = (split('::', ref($self)))[-1] . ':';
    return join(' ', $name,
		map  { "'$_'"  }
		grep { defined } @$self{ $self->_json_keys });
}
1;
