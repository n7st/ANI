#!/usr/bin/env perl -T

use strict;
use warnings;

use Test::Pod;

all_pod_files_ok(all_pod_files(qw(bin lib)));

