package GalaxyAPI::Library;

use strict;
use warnings;

use GalaxyAPI::LibraryContents;

use base qw{GalaxyAPI::BaseObject};

sub new_from_hash {
    my $pkg  = shift;
    my $self = $pkg->SUPER::new_from_hash( @_ );
    ## my $contents = GalaxyAPI::LibraryContents->new_from_hash( $self->{'contents'} );
    ## $self->{'contents'} = $contents;
    return $self;
}

sub synopsis     :lvalue { $_[0]->{'synopsis'};     }
sub description  :lvalue { $_[0]->{'description'};  }
sub contents_url :lvalue { $_[0]->{'contents_url'}; }

sub contents {
    my ($self, $contents) = @_;

    if ($contents and ref($contents) eq 'GalaxyAPI::LibraryContents') {
	$self->{'contents'} = $contents;
    }

    return $self->{'contents'};
}

1;
