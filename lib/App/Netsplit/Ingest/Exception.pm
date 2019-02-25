package App::Netsplit::Ingest::Exception;

use Moo;
use Types::Standard 'Str';

################################################################################

has message => (is => 'ro', isa => Str, required => 0);

################################################################################

1;

