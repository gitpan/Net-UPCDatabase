use Test::More tests => 5;

BEGIN { use_ok('Net::UPCDatabase'); }

SKIP: {

  eval { require Net::UPCDatabase };

  skip "Net::UPCDatabase not found, but was required", 4 if $@;

  my $upcdb = Net::UPCDatabase->new;
  isa_ok($upcdb, 'Net::UPCDatabase');

  my $goodUpc = '035000764119';
  my $item = $upcdb->lookup($goodUpc);
  ok(!$item->{error}, 'lookup (test good upc) '.$item->{error});

  my $badUpc1 = '035000764118';
  my $item = $upcdb->lookup($badUpc1);
  ok($item->{error}, 'lookup (test bad checksum) '.$item->{error});

  my $badUpc2 = '03500076411';
  my $item = $upcdb->lookup($badUpc2);
  ok($item->{error}, 'lookup (test bad length) '.$item->{error});

}
