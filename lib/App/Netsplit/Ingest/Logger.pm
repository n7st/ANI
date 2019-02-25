package App::Netsplit::Ingest::Logger;

use Mojo::Log;
use Moo;
use Types::Standard qw(HashRef InstanceOf);

with 'App::Netsplit::Ingest::Role::Config';

################################################################################

has levels => (is => 'ro', isa => HashRef,                 lazy => 1, builder => '_build_levels');
has logger => (is => 'ro', isa => InstanceOf['Mojo::Log'], lazy => 1, builder => '_build_logger');

################################################################################

sub _build_levels {
    # From Mojo::Log %LEVEL
    return {
        debug => 1,
        info  => 1,
        warn  => 1,
        error => 1,
        fatal => 1,
    };
}

sub _build_logger {
    my $self = shift;

    my $logger = Mojo::Log->new();
    my $level  = $self->config->{log_level};

    # Check the user-configured log level is valid for Mojo::Log
    if ($level && $self->levels->{$level}) {
        $logger->level($level);
    } else {
        $logger->warn(sprintf('%s is not a valid log level', $level));
    }

    return $logger;
}

################################################################################

1;

