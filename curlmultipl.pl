#!/usr/bin/perl -w

use strict;
use warnings;
use WWW::Curl::Easy;
use WWW::Curl::Multi;
use Data::Dumper;


my @urls = qw!
http://www.moserware.com/2009/06/first-few-milliseconds-of-https.html
http://trueslant.com/milesobrien/2009/06/10/the-paradox-of-simplicity
http://sethgodin.typepad.com/seths_blog/2009/06/guy-3.html
http://uswaretech.com/blog/2009/06/bing-python-api
!;

# my @urls = qw!
# http://www.google.com
# http://slashdot.org
# !;



print "pid $$ \n";

my (%easy,%responsebody,$active_handles,$id);
my $curlm = WWW::Curl::Multi->new;

( $active_handles,$id) = (0,1);

foreach my $u(@urls) {
  my $curl = WWW::Curl::Easy->new;
  my $curl_id = $id;
  $easy{$id} = $curl;
  $curl->setopt(CURLOPT_PRIVATE,$curl_id);
  $curl->setopt(CURLOPT_VERBOSE,1);
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


