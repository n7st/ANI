#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Test::Exception;
use Test::MockObject;
use Test::Most;

use lib "$FindBin::RealBin/../lib";

use App::Netsplit::Injest::Process;

ok my $process = App::Netsplit::Injest::Process->new();

my $ex = 'App::Netsplit::Injest::Exception::NotImplementedError';

throws_ok { $process->source      } $ex, 'Source threw correctly';
throws_ok { $process->destination } $ex, 'Destination threw correctly';

$process = App::Netsplit::Injest::Process->new({
    source      => Test::MockObject->new(),
    destination => Test::MockObject->new(),
});

lives_ok { $process->source      } 'Source overridden, no death';
lives_ok { $process->destination } 'Destination overridden, no death';

done_testing();

