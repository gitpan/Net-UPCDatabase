use strict;
use Test::More tests => 5;

BEGIN { use_ok('Net::UPCDatabase'); }

SKIP: {

  eval { require Net::UPCDatabase };

  skip "Net::UPCDatabase not found, but was required", 4 if $@;

  my $upcdb = Net::UPCDatabase->new;
  isa_ok($upcdb, 'Net::UPCDatabase');

  my $goodUpc = '035000764119';
  my $item1 = $upcdb->lookup($goodUpc);
  ok(!$item1->{error}, 'lookup (test good upc) '.$item1->{error});

  my $badUpc1 = '035000764118';
  my $item2 = $upcdb->lookup($badUpc1);
  ok($item2->{error}, 'lookup (test bad checksum) '.$item2->{error});

  my $badUpc2 = '03500076411';
  my $item3 = $upcdb->lookup($badUpc2);
  ok($item3->{error}, 'lookup (test bad length) '.$item3->{error});

}
