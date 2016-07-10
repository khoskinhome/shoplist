#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Khaos::ShopList;
Khaos::ShopList->to_app;
