package GalaxyAPI::LibraryContent;

use strict;
use warnings;

use GalaxyAPI::Utils::Arguments qw{rearrange};
use base qw{GalaxyAPI::BaseObject};

sub new {
    my $pkg  = shift;
    my $self = $pkg->SUPER::new(@_);
    my ($id, $type, $dbkey, $upload, $paths, $create) 
	= rearrange([qw(FOLDER_ID FILE_TYPE DBKEY UPLOAD_OPTION
			FILESYSTEM_PATHS CREATE_TYPE)], @_);
    
    $self->folder_id        = $id     if $id;
    $self->file_type        = $type   if $type;
    $self->dbkey            = $dbkey  if $dbkey;
    $self->upload_option    = $upload if $upload;
    $self->filesystem_paths = $paths  if $paths;
    $self->create_type      = $create if $create;
    
    return $self;
}

sub new_from_hash {
    my $pkg  = shift;
    my $self = $pkg->SUPER::new_from_hash(@_);
    @$self{qw(folder_id)} = @$self{qw(id)};
    return $self;
}

sub id {
    my $self = shift;
    $self->folder_id = $_[0] if $_[0];
    return $self->folder_id;
}

sub folder_id        :lvalue { $_[0]->{'folder_id'};        }
sub file_type        :lvalue { $_[0]->{'file_type'};        }
sub dbkey            :lvalue { $_[0]->{'dbkey'};            }
sub upload_option    :lvalue { $_[0]->{'upload_option'};    }
sub filesystem_paths :lvalue { $_[0]->{'filesystem_paths'}; }
sub create_type      :lvalue { $_[0]->{'create_type'};      }

sub _json_keys {
    my $self = shift;
    return ($self->SUPER::_json_keys(), 
	    qw(folder_id        file_type 
	       dbkey            upload_option 
	       filesystem_paths create_type));
}

1;
