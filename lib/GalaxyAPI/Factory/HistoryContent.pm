package GalaxyAPI::Factory::HistoryContent;

use strict;
use warnings;

use GalaxyAPI::HistoryContent;

use base qw{GalaxyAPI::Factory::History};

sub records_from_decoded_json {
    my ($self, $data) = @_;
    my @records;
    foreach my $entry(@$data){
	my $history = GalaxyAPI::HistoryContent->new_from_hash( $entry );
	push @records, $history;
    }
    return \@records;
}

1;
