#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Test::Most;

use lib "$FindBin::RealBin/../lib";

use App::Netsplit::Injest::Config;

use constant CFG_FILENAME => 't/etc/config.yml';

$ENV{ANI_CONFIG} = CFG_FILENAME;

my $util = App::Netsplit::Injest::Config->new();

is $util->filename, CFG_FILENAME, 'Config filename set correctly from env';

is ref $util->config, 'HASH', 'Config is a HashRef';

is $util->config->{log_level}, 'debug', 'Value from config is set correctly';

is ref $util->config->{processors}, 'ARRAY', 'Processors is an ArrayRef';

is ref $util->config->{destinations}, 'HASH', 'Destinations are a HashRef';

done_testing();

