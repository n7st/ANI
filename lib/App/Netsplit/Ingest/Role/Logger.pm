package App::Netsplit::Ingest::Role::Logger;

use Moo::Role;
use Types::Standard 'InstanceOf';

use App::Netsplit::Ingest::Logger;

################################################################################

has logger => (is => 'ro', isa => InstanceOf['Mojo::Log'], lazy => 1, builder => '_build_logger');

################################################################################

sub _build_logger {
    return App::Netsplit::Ingest::Logger->new->logger;
}

################################################################################

1;

