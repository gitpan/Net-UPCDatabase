package Net::UPCDatabase;

use 5.008;

our $VERSION = '0.03';

our $DEFAULTURL = 'http://www.upcdatabase.com/rpc';

sub new {
  my $class = shift;
  my $self = bless({}, $class);
  my %arg = @_;
  $self->{_url} = $arg{url} || $DEFAULTURL;
  use RPC::XML;
  use RPC::XML::Client;
  $self->{_rpcClient} = RPC::XML::Client->new($self->{_url});
  return $self;
}

sub lookup {
  my $self = shift;
  my $upc = shift;
  my $data = $self->{_rpcClient}->send_request('lookupUPC', $upc)->value;
  my $response = {};
  if (ref($data) eq "HASH") {
    $response = $data;
  }
  else {
    $response->{error} = $data;
  }
  return $response;
}

1;
__END__
=head1 NAME

Net::UPCDatabase - Simple OO interface to UPCDatabase.com

=head1 SYNOPSIS

  use Net::UPCDatabase;
  my $upcdb = Net::UPCDatabase->new;
  my $upc = '035000764119';
  my $item = $upcdb->lookup($upc);
  
  if ($item->{error}) {
    print "Error: $item->{error}\n";
  }
  else {
    print "UPC: $item->{upc}\n";
    print "Product: $item->{description}\n";
    print "Size: $item->{size}\n";
  }

=head1 DESCRIPTION

Connects to UPCDatabase.com to get information about a given UPC.

=head1 FUNCTIONS

=head2 new

 $upcObject = Net::UPCDatabase->new;

or

 $upcObject = Net::UPCDatabase->new($aDifferentUrlThanDefault);

Accepts an B<OPTIONAL> argument, a URL to use instead of the default.  Unless you're really sure what you're doing, don't give it a URL.  It defaults to 'http://www.upcdatabase.com/rpc', which is probably the right thing.

Returns the object.

=head2 lookup

 $itemInfo = $upcObject->lookup($upc);

Accepts a B<REQUIRED> argument, the UPC to lookup.

Returns the data about the given UPC in a hash reference.

On error, it returns the given error reason as C<< $itemInfo->{error} >>.

=head1 REQUIRES

C<RPC::XML>
C<RPC::XML::Client>

=head1 TODO

=over 3

=item UPC checksum checking/creation

Make use of the checksum function via UPCDatabase's API.

=item Better documentation

Is the documentation B<really> ever good enough?

=back

=head1 SEE ALSO

L<http://www.upcdatabase.com/>

=head1 AUTHOR

Dusty Wilson, E<lt>cpan-Net-UPCDatabase@dusty.hey.nuE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2005 by Dusty Wilson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
