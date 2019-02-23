package App::Netsplit::Injest::Exception;

use Moo;
use Types::Standard 'Str';

################################################################################

has message => (is => 'ro', isa => Str, required => 0);

################################################################################

1;

