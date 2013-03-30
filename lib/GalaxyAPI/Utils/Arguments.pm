package GalaxyAPI::Utils::Arguments;

use strict;
use warnings;

use Exporter;

use vars qw(@ISA @EXPORT);

@ISA    = qw(Exporter);
@EXPORT = qw(rearrange);

sub rearrange {
  my $order = shift;

  if ( $order eq "GalaxyAPI::Utils::Arguments" ) {
    # skip object if one provided
    $order = shift;
  }

  # If we've got parameters, we need to check to see whether
  # they are named or simply listed. If they are listed, we
  # can just return them.
  unless ( @_ && $_[0] && substr( $_[0], 0, 1 ) eq '-' ) {
    return @_;
  }
  
  # Push undef onto the end if % 2 != 0 to stop warnings
  push @_,undef unless $#_ %2;
  my %param;
  while( @_ ) {
    #deletes all dashes & uppercases at the same time
    (my $key = shift) =~ tr/a-z\055/A-Z/d;
    $param{$key} = shift;
  }
  
  # What we intend to do is loop through the @{$order} variable,
  # and for each value, we use that as a key into our associative
  # array, pushing the value at that key onto our return array.
  return map { $param{uc($_)} } @$order;
}

1;


