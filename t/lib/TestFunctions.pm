package TestFunctions;

###############################################################################
#
# TestFunctions - Helper functions for GalaxyAPI test cases
#
#

use 5.008002;
use Exporter;
use strict;
use warnings;
use Test::More;
use JSON;
use File::Spec;
use FindBin;

our @ISA         = qw(Exporter);
our @EXPORT      = ();
our %EXPORT_TAGS = ();
our @EXPORT_OK   = qw(_to_json _api_object_from_env);

our $VERSION = '0.00';

our ($API_USERNAME, $API_PASSWORD, $API_KEY, $API_URL) =
    @ENV{qw(API_USERNAME API_PASSWORD API_KEY API_URL)};

sub _to_json {
    my ($hash, $keys) = @_;
    my $json = JSON::XS->new();
    return $json->encode({ map { $_ => $hash->{$_} } $keys });
}

sub _api_object_from_env {
    my ($skip, $api) = (1);

    ##
    ## Firstly attempt to read the variable from the environment
    ## this is the non-developer option...
    ##
    $API_USERNAME ||= 'galaxy-admin';
    $API_PASSWORD ||= 'galaxy-admin';

    ##
    ## looking for '.env.pl' file in 't' directory or location of 
    ## current test script.
    ##
    my $require_file = File::Spec->catfile($FindBin::Bin, '.env.pl');
    eval { require $require_file; } if (-e $require_file);

    $skip = (($API_USERNAME && $API_PASSWORD && $API_KEY && $API_URL) ? 0 : 1);
    
    if ($skip == 0) {
	eval { require GalaxyAPI; };
	if (!$@) {
	    $api = GalaxyAPI->new(-api      => $API_URL, 
				  -api_key  => $API_KEY,
				  -debug    => $ENV{'API_DEBUG'},
				  -username => $API_USERNAME,
				  -password => $API_PASSWORD);
	} else { 
	    diag "$@";
	    $skip = 1;
	}
    } else {
	diag "skipping...";
    }
    
    return ($api, $skip);
}
