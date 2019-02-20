#!/usr/bin/env perl

use strict;
use warnings;

use DDP;
use Getopt::Long 'GetOptions';
use Mojo::UserAgent;
use Net::Telnet;
use InfluxDB::LineProtocol 'data2line';

my ($username, $password, $address, $influxdb_address);

GetOptions(
    'username|u=s' => \$username,
    'password|p=s' => \$password,
    'address|a=s'  => \$address,
    'influxdb|i=s' => \$influxdb_address,
);

my $util = Net::Telnet->new(
    timeout => 20,
    prompt  => '/[\$%#>]$/',
);

my $shell_prompt = '/# $/';

$util->open($address)              or die 'Server not found';
$util->login($username, $password) or die 'Invalid credentials';
$util->print('sh');
$util->prompt($shell_prompt);
$util->waitfor($shell_prompt);

my @lines = $util->cmd('xdslcmd info --pbParams');

my %stats = (
    status => '',

    attainable                => { up => -1, down => -1 },
    actual_aggregate_tx_power => { up => -1, down => -1 },
    current                   => { up => -1, down => -1 },
    max                       => { up => -1, down => -1 },
);

foreach (@lines) {
    if (/^Status:/) {
        ($stats{status}) = $_ =~ /^Status: (.+)/;
    } elsif (/^Bearer:\t+0/) {
        (
            $stats{current}->{up},
            $stats{current}->{down},
        ) = get_current_speed($_);
    } elsif (/^Max:\t+/) {
        (
            $stats{max}->{up},
            $stats{max}->{down},
        ) = get_current_speed($_);
    } elsif (/^Attainable Net Data Rate:/) {
        my $parts = line_to_parts($_);

        $stats{attainable}->{up}   = clean($parts->[0])->[0];
        $stats{attainable}->{down} = clean($parts->[1])->[0];
    } elsif (/^Actual Aggregate Tx Power:/) {
        my $parts = line_to_parts($_);

        $stats{actual_aggregate_tx_power}->{up}   = clean($parts->[0])->[0];
        $stats{actual_aggregate_tx_power}->{down} = clean($parts->[1])->[0];
    }
}

my $ua = Mojo::UserAgent->new();

foreach my $type (qw(attainable current max actual_aggregate_tx_power)) {
    if ($stats{$type}->{up} > 0 && $stats{$type}->{down} > 0) {
        write_entry(data2line($type, {
            upstream   => $stats{$type}->{up},
            downstream => $stats{$type}->{down},
        }));
    }
}

if ($stats{status}) {
    write_entry(data2line('status', { value => $stats{status} }));
}

p %stats;

################################################################################

sub write_entry {
    my $data = shift;

    my $tx = $ua->post($influxdb_address => {
        Accept => '*/*',
    } => $data);

    p $tx->res->body;

    # TODO: error handling

    return 1;
}

sub get_current_speed {
    my $input = shift;

    my ($up, $down) = $_ =~ /Upstream rate = (\d+) Kbps, Downstream rate = (\d+) Kbps/;

    return ($up, $down);
}

sub line_to_parts {
    my $line = shift;

    my @parts = split /\t+/;

    shift @parts;

    return \@parts;
}

sub clean {
    my $input = shift;

    chomp $input;

    $input =~ s/(^\s+|\s+$)//s;

    my ($stat, $metric) = split /\s+/, $input;

    return [ $stat, $metric ];
}

################################################################################

__END__

