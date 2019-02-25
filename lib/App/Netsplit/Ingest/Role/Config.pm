package App::Netsplit::Ingest::Role::Config;

use Moo::Role;
use Types::Standard 'HashRef';

use App::Netsplit::Ingest::Config;

################################################################################

has config => (is => 'ro', isa => HashRef, lazy => 1, builder => '_build_config');

################################################################################

sub _build_config {
    return App::Netsplit::Ingest::Config->new->config;
}

################################################################################

1;

