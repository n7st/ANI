#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Test::Most;

use lib "$FindBin::RealBin/../lib";

use App::Netsplit::Injest;

$ENV{ANI_CONFIG} = 't/etc/config.yml';

ok my $ani = App::Netsplit::Injest->new();

is $ani->ioloop_tick, 60, 'Default tick length is correct';

is ref $ani->processors, 'ARRAY', 'Processors are an ArrayRef';

is @{$ani->processors}, 1, 'One processor is configured';

done_testing();

