package App::Netsplit::Injest::Process;

use Moo;
use Types::Standard qw(Object Str);

use App::Netsplit::Injest::Exception::NotImplementedError;

with 'App::Netsplit::Injest::Role::Config';

################################################################################

has source      => (is => 'ro', isa => Object, lazy => 1, builder => '_build_source');
has destination => (is => 'ro', isa => Object, lazy => 1, builder => '_build_destination');

# TODO: when there are more destinations, this will be required
has destination_name => (is => 'ro', isa => Str, required => 0);

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

