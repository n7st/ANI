package App::Netsplit::Injest::Source::HG612;

use Moo;
use Net::Telnet;
use Types::Standard qw(InstanceOf Str);

################################################################################

has address  => (is => 'ro', isa => Str, required => 1);
has password => (is => 'ro', isa => Str, required => 0);
has username => (is => 'ro', isa => Str, required => 0);

has scheme => (is => 'ro', isa => Str, default => 'http');

has prompt  => (is => 'ro', isa => Str, default => '/# $/');
has command => (is => 'ro', isa => Str, default => 'xdslcmd info --pbParams');

################################################################################

sub poll {
    my $self = shift;

    my $telnet = Net::Telnet->new(
        prompt  => '/[\$%#>]$/',
        timeout => 20,
    );

    # TODO: exceptions
    $telnet->open($self->address);
    $telnet->login($self->username, $self->password);

    $telnet->print('sh');
    $telnet->prompt($self->prompt);
    $telnet->waitfor($self->prompt);

    return $self->_parse_stats([ $telnet->cmd($self->command) ]);
}

################################################################################

sub _clean_value {
    my $self  = shift;
    my $input = shift;

    chomp $input;

    $input =~ s/(^\s+|\s+$)//s;

    my ($stat, $metric) = split /\s+/, $input;

    return [ $stat, $metric ];
}

sub _line_to_speeds {
    my $self  = shift;
    my $input = shift;

    my ($up, $down) = $_ =~ /Upstream rate = (\d+) Kbps, Downstream rate = (\d+) Kbps/;

    return ($up, $down);
}

sub _line_to_parts {
    my $self  = shift;
    my $input = shift;

    my @parts = split /\t+/, $input;

    shift @parts;

    return \@parts;
}

sub _parse_stats {
    my $self  = shift;
    my $lines = shift;

    my %stats = (
        status => '',

        attainable                => { up => -1, down => -1 },
        actual_aggregate_tx_power => { up => -1, down => -1 },
        current                   => { up => -1, down => -1 },
        max                       => { up => -1, down => -1 },
    );

    foreach (@{$lines}) {
        if (/^Status:/) {
            ($stats{status}) = $_ =~ /^Status: (.+)/;
        } elsif (/^Bearer:\t+0/) {
            ($stats{current}->{up}, $stats{current}->{down}) = $self->_line_to_speeds($_);
        } elsif (/^Max:\t+/) {
            ($stats{max}->{up}, $stats{max}->{down}) = $self->_line_to_speeds($_);
        } elsif (/^Attainable Net Data Rate:/) {
            my $parts = $self->_line_to_parts($_);

            $stats{attainable}->{up}   = $self->_clean_value($parts->[0])->[0];
            $stats{attainable}->{down} = $self->_clean_value($parts->[1])->[0];
        } elsif (/^Actual Aggregate Tx Power:/) {
            my $parts = $self->_line_to_parts($_);

            $stats{actual_aggregate_tx_power}->{up}   = $self->_clean_value($parts->[0])->[0];
            $stats{actual_aggregate_tx_power}->{down} = $self->_clean_value($parts->[1])->[0];
        }
    }

    return \%stats;
}

################################################################################

1;

