#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Test::Exception;
use Test::Most;

use lib "$FindBin::RealBin/../lib";

use App::Netsplit::Injest::Process::HG612;

$ENV{ANI_CONFIG} = 't/etc/config.yml';

ok my $hg612 = App::Netsplit::Injest::Process::HG612->new();

lives_ok { $hg612->source      } 'Source is set';
lives_ok { $hg612->destination } 'Destination is set';

is $hg612->_status_to_i('Showtime'),  4, 'Showtime';
is $hg612->_status_to_i('Training'),  3, 'Training';
is $hg612->_status_to_i('Handshake'), 2, 'Handshake';
is $hg612->_status_to_i('Idle'),      1, 'Idle';
is $hg612->_status_to_i('Unknown'),   0, 'Unknown';

ok $hg612->can('process'), 'Process is possible';

is $hg612->influxdb_database, 'hg612', 'Output database set';

done_testing();

