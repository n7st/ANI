package App::Netsplit::Ingest::Destination::InfluxDB;

use Mojo::UserAgent;
use Moo;
use Types::Standard qw(InstanceOf Str);
use InfluxDB::LineProtocol 'data2line';

with 'App::Netsplit::Ingest::Role::Logger';

################################################################################

has address  => (is => 'ro', isa => Str, required => 1);
has database => (is => 'ro', isa => Str, required => 1);
has password => (is => 'ro', isa => Str, required => 0);
has username => (is => 'ro', isa => Str, required => 0);

has scheme => (is => 'ro', isa => Str, default => 'http');

has ua  => (is => 'ro', isa => InstanceOf['Mojo::UserAgent'], lazy => 1, builder => '_build_ua');
has url => (is => 'ro', isa => Str,                           lazy => 1, builder => '_build_url');

################################################################################

sub write_entry {
    my $self  = shift;
    my $table = shift;
    my $input = shift;

    my $res = $self->ua->post($self->url => {
        Accept => '*/*',
    } => data2line($table, $input))->res;

    unless ($res->is_success) {
        $self->logger->warn(sprintf('Bad response: %d - %s', $res->code, $res->message));

        return 0;
    }

    return 1;
}

################################################################################

sub _build_ua {
    return Mojo::UserAgent->new();
}

sub _build_url {
    my $self = shift;

    my $url = sprintf('%s/write?db=%s', $self->address, $self->database);

    if ($self->username && $self->password) {
        # Basic auth
        $url = sprintf('%s:%s@%s', $self->username, $self->password, $url);
    }

    return sprintf('%s://%s', $self->scheme, $url);
}

################################################################################

1;

