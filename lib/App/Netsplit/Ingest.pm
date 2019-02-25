package App::Netsplit::Ingest;

use Mojo::IOLoop;
use Mojo::IOLoop::Delay;
use Moo;
use Time::Seconds;
use Types::Standard qw(ArrayRef Int);

with qw(
    App::Netsplit::Ingest::Role::Config
    App::Netsplit::Ingest::Role::Logger
);

################################################################################

has ioloop_tick => (is => 'ro', isa => Int, default => Time::Seconds::ONE_MINUTE);

has processors => (is => 'ro', isa => ArrayRef, lazy => 1, builder => '_build_processors');

################################################################################

sub poll {
    my $self = shift;

    if ($self->config->{active_polling}) {
        $self->logger->info('Active polling');

        Mojo::IOLoop->recurring($self->ioloop_tick => sub {
            $self->logger->debug('Tick');

            return $self->_poll_real();
        });

        Mojo::IOLoop->start();
    } else {
        $self->logger->info('Inactive polling');

        $self->_poll_real();
    }

    return 0;
}

################################################################################

sub _poll_real {
    my $self = shift;

    foreach my $processor (@{$self->processors}) {
        unless ($processor->process()) {
            $self->logger->warn('Failed to process in '.ref $processor);
        }
    }

    return 1;
}

################################################################################

sub _build_processors {
    my $self = shift;

    my @processors;

    foreach my $processor (@{$self->config->{processors}}) {
        my $poller_class = sprintf('App::Netsplit::Ingest::Process::%s', $processor->{source});

        # Dynamically require processor modules
        eval "require ${poller_class}";

        if ($@) {
            $self->logger->warn($@);
        }

        push @processors, $poller_class->new({
            destination_name => $processor->{destination},
        });
    }

    return \@processors;
}

################################################################################

1;

