=pod

=head1 NAME

GalaxyAPI - Galaxy API

=head1 DESCRIPTION

=cut

package GalaxyAPI;

use strict;
use warnings;

use URI::Split qw{uri_split};
use HTTP::Status;
use REST::Client;
use HTTP::Cookies;
use JSON;

use GalaxyAPI::Utils::Arguments qw{rearrange};
use GalaxyAPI::Utils::Scalar    qw{check_ref};
use GalaxyAPI::Factory::History;
use GalaxyAPI::Factory::HistoryContent;
use GalaxyAPI::Factory::Library;
use GalaxyAPI::Factory::LibraryContent;
use GalaxyAPI::Factory::User;
use GalaxyAPI::Factory::Workflow;

our $VERSION = 0.01;

sub new {
    my $pkg  = shift;
    my $self = bless { 
	_client_init_run => 0,
	debug            => 0,
    }, $pkg;

    my $cli = $self->client = REST::Client->new(follow => 1);
    my ($api_url, $api_key, $debug, $username, $password) 
	= rearrange([qw(API API_KEY DEBUG USERNAME PASSWORD)], @_);
    if ($api_url){
	my ($s, $h, $p) = uri_split($api_url);
	$self->host = "$h:80";
	$cli->setHost( $api_url );
    }
    
    my $cookie_file   = "$ENV{HOME}/.galaxy-api.cookiejar";
    $self->debug      = $debug if $debug;
    $self->api_key    = $api_key;
    $self->cookie_jar = HTTP::Cookies->new(file     => $cookie_file,
					   autosave => 1);
    $self->username   = $username if $username;
    $self->password( $password )  if $password;

    $self->{'_factories'} = { 
	map { lc $_ => "GalaxyAPI::Factory::$_"->new() } qw(History HistoryContent
							    Library LibraryContent
							    User Workflow)
	};

    return $self;
}

sub debug      :lvalue { $_[0]->{'debug'};      }
sub cookie_jar :lvalue { $_[0]->{'cookie_jar'}; }
sub client     :lvalue { $_[0]->{'client'};     }
sub api_key    :lvalue { $_[0]->{'api_key'};    }
sub host       :lvalue { $_[0]->{'host'};       }
sub realm      :lvalue { $_[0]->{'realm'};      }
sub username   :lvalue { $_[0]->{'username'};   }
sub password {
    my $self = shift;
    my $pass = shift;
    $self->{'password'} = sub { return $pass; } if $pass;
    return $self->{'password'} || sub { return ''; };
}

sub credentials {
    my $self = shift;

    my ($user, $pass) = splice(@_, -2, 2) if @_;
    $self->username = $user  if $user;
    $self->password( $pass ) if $pass;

    my ($host, $realm) = @_;
    $self->host  = $host  if $host;
    $self->realm = $realm if $realm;

    warn join(" ", " * credentials", map { "'$_'" }
	      $self->host || '', $self->realm || '', 
	      $self->username,
	      $self->password->()), "\n" if $self->debug;

    my $ua = $self->client->getUseragent;
    return $ua->credentials($self->host, $self->realm, 
			    $self->username => $self->password->());
}

sub request {
    my ($self, $m, $uri, $body, $head) = @_;
    my $url = $self->_add_api_key($uri);
    my $cli = $self->client;
    my $run = {
	'get'   => sub { $cli->GET($url);   },
	'post'  => sub { $cli->POST($url, $body, $head);  },
	'put'   => sub { $cli->PUT($url);   },
	'patch' => sub { $cli->PATCH($url); },
    }->{lc $m};

    $self->_client_init( $cli );
    my $res = $run->();

    return $res->{_res};
}

sub get {
    my $self = shift;
    my $resp = $self->request('get', @_);
    return $resp->content;
}

sub put {
    my $self = shift;
    my $resp = $self->request('put', @_);
    return $resp->content;
}

sub factory {
    my ($self, $type) = @_;
    $type = lc((split(/::/, $type))[-1]);
    return $self->{'_factories'}{$type};
}

sub workflows {
    my $self    = shift;
    my $factory = $self->factory('GalaxyAPI::Factory::Workflow');
    return $factory->run( $self, @_ );
}

sub libraries {
    my $self    = shift;
    my $factory = $self->factory('library');
    return $factory->run( $self, @_ );
}

sub library_contents {
    my $self    = shift;
    my $factory = $self->factory('LibraryContent');
    if(check_ref($_[0], 'ARRAY')) {
	push @{$_[0]}, 'contents' unless $_[0]->[-1] eq 'contents';
    } else {
	warn "need an id\n";
    }
    return $factory->run( $self, @_ );
}

sub users {
    my $self    = shift;
    my $factory = $self->factory('user');
    return $factory->run( $self, @_ );
}

sub histories {
    my $self    = shift;
    my $factory = $self->factory('history');
    return $factory->run( $self, @_ );
}

sub history_contents {
    my $self    = shift;
    my $factory = GalaxyAPI::Factory::HistoryContent->new();
    if (check_ref($_[0], 'ARRAY')) {
	push @{$_[0]}, 'contents' unless $_[0]->[-1] eq 'contents';
    } elsif ( check_ref($_[0], 'GalaxyAPI::History') ) {
	my $history = shift @_;
	unshift @_, $history->contents_uri;
    } else {
	warn "need an id\n";
    }
    return $factory->run( $self, @_ );
}

## -------------------------------------------------------------------
## 
## 
## 
## -------------------------------------------------------------------

sub _add_api_key {
    my $self = shift;
    my $url  = shift;
    my $args = {};
    my ($s, $a, $p, $q, $f) = uri_split($url);

    my @path    = ( map { split /=/, $_, 2 } split /&/, $q || '' );
    my $query   = $self->client->buildQuery(@path, key => $self->api_key);
    my $mod_url = sprintf("%s%s", $p, $query);

    return $mod_url;
}

sub _client_init {
    my ($self, $cli) = @_;

    $self->_init_user_agent( $cli->getUseragent );

    if ($self->{'_client_init_run'} == 0) {

	my $init_url = $self->_add_api_key('/');
	warn " * initialising... ($init_url) \n" if $self->debug;

	$self->client->getUseragent->add_handler('response_header' => sub {
	    my ($response, $ua, $h) = @_;
	    my $self = $h->{'data'};

	    warn " * got response code: ", $response->code, "\n" if $self->debug;

	    if ($response->code == &HTTP::Status::RC_UNAUTHORIZED) { 
		my $basic_realm = $response->header('www-authenticate');
		## 'Basic realm="..."
		if ($basic_realm =~ m/Basic\srealm=\"([^\"]+)\"/) {
		    $self->realm = $1;
		}
	    }
	}, data => $self);

	$cli->GET( $init_url );

	$self->{'_client_init_run'} = 1;
    }

    $self->credentials($self->username, $self->password->());

    return 0;
}

sub _init_user_agent {
    my ($self, $ua) = @_;

    $ua->cookie_jar( $self->cookie_jar );
    $ua->default_header('Accept-Encoding' => scalar HTTP::Message::decodable());
    $ua->default_header('Accept-Language' => 'en');
    $ua->default_header('Content-Type'    => 'application/json');
    $ua->protocols_allowed([qw{http https}]);
    $ua->requests_redirectable([qw{GET POST}]);
    $ua->no_proxy([qw{ galaxy-test.pfr.co.nz }]);

    if ($self->debug > 1) {
	$ua->add_handler('request_send'  => sub { warn shift->dump; return; });
	$ua->add_handler('response_done' => sub { warn shift->dump; return; });
    }
}

1;
