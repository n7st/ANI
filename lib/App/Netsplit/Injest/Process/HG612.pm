package App::Netsplit::Injest::Process::HG612;

use Moo;
use Types::Standard 'Str';
use Switch::Plain;

use App::Netsplit::Injest::Destination::InfluxDB;
use App::Netsplit::Injest::Source::HG612;

extends 'App::Netsplit::Injest::Process';

################################################################################

has influxdb_database => (is => 'ro', isa => Str, lazy => 1, builder => '_build_influxdb_database');

################################################################################

sub process {
    my $self = shift;

    my $report = $self->source->poll();

    foreach my $type (qw(actual_aggregate_tx_power current max)) {
        if ($report->{$type}->{up} > 0 && $report->{$type}->{down} > 0) {
            $self->destination->write_entry($type, {
                upstream    => $report->{$type}->{up},
                downstream  => $report->{$type}->{down},
            });
        }
    }

    if ($report->{status}) {
        $self->destination->write_entry('status', {
            value => $report->{status},
        });

        $self->destination->write_entry('status_i', {
            value => $self->_status_to_i($report->{status}),
        });
    }

    return 0;
}

################################################################################

sub _status_to_i {
    my $self   = shift;
    my $status = shift;

    my $i = 0;

    sswitch ($status) {
        case 'Showtime':  { $i = 4 }
        case 'Training':  { $i = 3 }
        case 'Handshake': { $i = 2 }
        case 'Idle':      { $i = 1 }
    }

    return $i;
}

################################################################################

sub _build_destination {
    my $self = shift;

    return App::Netsplit::Injest::Destination::InfluxDB->new({
        address  => $self->config->{destinations}->{influxdb}->{address},
        database => $self->influxdb_database,
        scheme   => $self->config->{destinations}->{influxdb}->{scheme},
    });
}

sub _build_influxdb_database {
    my $self = shift;

    return $self->config->{sources}->{hg612}->{influxdb_database};
}

sub _build_source {
    my $self = shift;

    return App::Netsplit::Injest::Source::HG612->new({
        address  => $self->config->{sources}->{hg612}->{address},
        password => $self->config->{sources}->{hg612}->{password},
        username => $self->config->{sources}->{hg612}->{username},
    });
}

################################################################################

1;

