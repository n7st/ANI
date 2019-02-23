package App::Netsplit::Injest::Role::Config;

use Moo::Role;
use Types::Standard 'HashRef';

use App::Netsplit::Injest::Config;

################################################################################

has config => (is => 'ro', isa => HashRef, lazy => 1, builder => '_build_config');

################################################################################

sub _build_config {
    return App::Netsplit::Injest::Config->new->config;
}

################################################################################

1;

