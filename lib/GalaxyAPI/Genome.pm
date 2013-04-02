package GalaxyAPI::Genome;

use strict;
use warnings;

use Digest::MD5 qw{md5_hex};

use GalaxyAPI::Utils::Arguments qw{rearrange};
use GalaxyAPI::Utils::Scalar    qw{check_ref};
use GalaxyAPI::Chromosome;
use base qw{GalaxyAPI::BaseObject};

sub new {
    my $pkg  = shift;
    my ($desc, $name, $reference, $next_chroms, $prev_chroms, $chrs, 
	$start_index, $owner) 
	= rearrange([qw(DESCRIPTION NAME REFERENCE NEXT_CHROMS PREV_CHROMS 
			CHROM_INFO START_INDEX OWNER)], @_);
    my $self = bless {
	description => $desc,
	name        => $name,
	id          => $name,
	url         => sprintf('/api/genomes/%s', 
			       $owner ? "$owner:$name" : $name),
    }, ref($pkg) || $pkg;

    $self->reference   = $reference   if $reference;
    $self->next_chroms = $next_chroms if $next_chroms;
    $self->prev_chroms = $prev_chroms if $prev_chroms;
    $self->start_index = $start_index if $start_index;

    $self->chromosomes( $chrs );

    return $self;
}

sub new_from_hash { 
    my $pkg = shift;
    my $self;
    if (check_ref($_[0], 'HASH')) {
	$self = bless $_[0], ref($pkg) || $pkg;
    } else {
	my $obj = {};
	if(check_ref($_[0], 'ARRAY')) {
	    my ($desc, $name, $owner) = @{$_[0]};
	    $obj = { 
		description => $desc,
		name        => $name,
		id          => $name,
		url         => sprintf('/api/genomes/%s', 
				       $owner ? "$owner:$name" : $name),
	    };
	}
	$self = bless $obj, ref($pkg) || $pkg;
    }
    return $self;
}
sub description :lvalue { $_[0]->{'description'}; }
sub reference   :lvalue { $_[0]->{'reference'};   }
sub next_chroms :lvalue { $_[0]->{'next_chroms'}; }
sub prev_chroms :lvalue { $_[0]->{'prev_chroms'}; }
sub start_index :lvalue { $_[0]->{'start_index'}; }

sub chromosomes {
    my $self        = shift;
    my $chromosomes = shift;
    if (check_ref($chromosomes, 'ARRAY') && 
	check_ref($chromosomes->[0], 'HASH')) {
	$self->{'chrom_info'} = 
	    [ map { GalaxyAPI::Chromosome->new_from_hash( $_ ) } @$chromosomes ];
    }
    return $self->{'chrom_info'};
}

sub _extra_json_keys {
    return qw(description reference next_chroms prev_chroms start_index chrom_info);
}

1;
