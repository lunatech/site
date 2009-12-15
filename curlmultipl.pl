#!/usr/bin/perl -w

use strict;
use warnings;
use WWW::Curl::Easy;
use WWW::Curl::Multi;
use Data::Dumper;


my @urls = qw!
http://www.tldp.org/HOWTO/text/Wireless-HOWTO
http://www.tldp.org/HOWTO/text/WikiText-HOWTO
http://www.tldp.org/HOWTO/text/Virtual-Services-HOWTO
http://www.tldp.org/HOWTO/text/User-Authentication-HOWTO
http://www.tldp.org/HOWTO/text/Usenet-News-HOWTO
http://www.tldp.org/HOWTO/text/TransparentProxy
http://www.tldp.org/HOWTO/text/Tips-HOWTO
!;

my (%easy,%responsebody,$active_handles,$id);
my $curlm = WWW::Curl::Multi->new;

( $active_handles,$id) = (0,1);

foreach my $u(@urls) {
  my $curl = WWW::Curl::Easy->new;
  my $curl_id = $id;
  $easy{$id} = $curl;
  $curl->setopt(CURLOPT_PRIVATE,$curl_id);
#  $curl->setopt(CURLOPT_VERBOSE,1);
  $curl->setopt(CURLOPT_URL,$u);
  open (my $fileb, ">", \$responsebody{$u});
  $curl->setopt(CURLOPT_WRITEDATA,$fileb);
  $curlm->add_handle($curl);
  $active_handles++;$id++;
}
  
  
while ($active_handles) {
  my $active_transfers = $curlm->perform;
  if ($active_transfers != $active_handles) {
    while (my ($id,$return_value) = $curlm->info_read) {
      if ($id) {
	$active_handles--;
	my $actual_easy_handle = $easy{$id};
	# do the usual result/error checking routine here
	# letting the curl handle get garbage collected, or we leak memory.
	delete $easy{$id};
      }
    }
  }
}


