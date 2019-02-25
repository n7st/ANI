#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Test::Most;

use lib "$FindBin::RealBin/../lib";

use App::Netsplit::Ingest::Config;

use constant CFG_FILENAME => 't/etc/config.yml';

is(App::Netsplit::Ingest::Config->new->filename, 'config.yml', 'Default filename');

$ENV{ANI_CONFIG} = CFG_FILENAME;

my $util = App::Netsplit::Ingest::Config->new();

is $util->filename, CFG_FILENAME, 'Config filename set correctly from env';

is ref $util->config, 'HASH', 'Config is a HashRef';

is $util->config->{log_level}, 'debug', 'Value from config is set correctly';

is ref $util->config->{processors}, 'ARRAY', 'Processors is an ArrayRef';

is ref $util->config->{destinations}, 'HASH', 'Destinations are a HashRef';

done_testing();

