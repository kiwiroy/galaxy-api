package GalaxyAPI::Utils::Scalar;

use strict;
use warnings;

use Exporter;
use Scalar::Util qw{blessed};

use vars qw(@ISA @EXPORT);

our @ISA    = qw(Exporter);
our @EXPORT = qw(check_ref ensure_array uri_array);

sub check_ref {
    my ($ref, $expect) = @_;
    my $retval = 0;

    if (defined $ref) {
	if(blessed $ref) {
	    $retval = 1 if ($ref->isa($expect));
	} else {
	    my $type = ref($ref);
	    $retval = 1 if (defined $type && $type eq $expect);
	}
    }

    return $retval;
}

sub ensure_array {
    my ($input) = @_;
    
    my $output  = ( check_ref( $input, 'ARRAY' ) ?
		    $input                       : [ $input ] );
    
    return $output;
}

sub uri_array {
    my ($url, $shift) = @_;
    $shift ||= 2;
    my @uri  = split m!/!, $url || '';
    splice(@uri, 0, $shift, ());
    return \@uri;
}

1;
