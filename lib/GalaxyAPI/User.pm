package GalaxyAPI::User;

use strict;
use warnings;

use Email::Address;

use GalaxyAPI::Utils::Arguments qw{rearrange};

use base qw{GalaxyAPI::BaseObject};

sub new {
    my $pkg  = shift;
    my $self = $pkg->SUPER::new( @_ );
    my ($email, $quotap, $username) =
	rearrange([qw(EMAIL QUOTA_PERCENT USERNAME)], @_);
    $self->email    = $email    if $email && $email =~ /^$Email::Address::mailbox$/;
    $self->quotap   = $quotap   if $quotap;
    $self->username = $username if $username;
    return $self;
}

sub email           :lvalue { $_[0]->{'email'};                 }
sub username        :lvalue { $_[0]->{'username'};              }
sub quota_percent   :lvalue { $_[0]->{'quota_percent'};         }
sub disk_usage      :lvalue { $_[0]->{'total_disk_usage'};      }
sub nice_disk_usage :lvalue { $_[0]->{'nice_total_disk_usage'}; }

sub _extra_json_keys {
    return qw(email username quota_percent total_disk_usage nice_total_disk_usage);
}


1;
