=pod

=head1 NAME

GalaxyAPI::Chromosome - Very simple representation

=head1 DESCRIPTION

A very simple representation of a chromosome for use in the
GalaxyAPI::Genome object.

=head1 SYNOPSIS

 $chr = GalaxyAPI::Chromosome->new(-name   => 'chr1', 
                                   -length => 1e6);
 $length = $chr->length;
 $name   = $chr->name;
 
Or for experts

 $chr = GalaxyAPI::Chromosome->new_from_hash({
   chrom => 'chr1', len => 1e6
 });
 
Like I said, _very_ simple!

=cut

package GalaxyAPI::Chromosome;

use strict;
use warnings;
use GalaxyAPI::Utils::Arguments qw{rearrange};

sub new {
    my $pkg  = shift;
    my ($name, $len) = rearrange([qw(NAME LENGTH)], @_);
    my $self = bless {
	chrom => $name,
	len   => $len,
    }, ref($pkg) || $pkg;
    return $self;
}

sub new_from_hash {
    my $pkg = shift;
    return bless $_[0], ref($pkg) || $pkg;
}

sub name   :lvalue { $_[0]->{'chrom'}; }
sub length :lvalue { $_[0]->{'len'};   }

1;
