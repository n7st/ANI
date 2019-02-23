package App::Netsplit::Injest::Process;

use Moo;
use Types::Standard 'Object';

use App::Netsplit::Injest::Exception::NotImplementedError;

with 'App::Netsplit::Injest::Role::Config';

################################################################################

has source      => (is => 'ro', isa => Object, lazy => 1, builder => '_build_source');
has destination => (is => 'ro', isa => Object, lazy => 1, builder => '_build_destination');

################################################################################

sub _build_source {
    App::Netsplit::Injest::Exception::NotImplementedError->throw({
        message => '_build_source not overridden in child class',
    });
}

sub _build_destination {
    App::Netsplit::Injest::Exception::NotImplementedError->throw({
        message => '_build_destination not overridden in child class',
    });
}

################################################################################

1;
