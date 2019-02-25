package App::Netsplit::Ingest::Config;

use Moo;
use Types::Standard qw(HashRef Str);
use YAML::Syck      'LoadFile';

################################################################################

has config   => (is => 'ro', isa => HashRef, lazy => 1, builder => '_build_config');
has filename => (is => 'ro', isa => Str,     lazy => 1, builder => '_build_filename');

has default_filename => (is => 'ro', isa => Str, default => 'config.yml');
has filename_env_var => (is => 'ro', isa => Str, default => 'ANI_CONFIG');

################################################################################

sub _build_config {
    my $self = shift;

    return LoadFile($self->filename);
}

sub _build_filename {
    my $self = shift;

    # A custom config file location can be set by setting the ANI_CONFIG
    # environment variable
    return $ENV{$self->filename_env_var} || $self->default_filename;
}

################################################################################

1;

