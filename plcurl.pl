#!/usr/bin/perl -w

use strict;
use warnings;
use WWW::Curl::Easy;

# Setting the options
my $curl = new WWW::Curl::Easy;
            
my $response_body;
my $response_header;

# NOTE - do not use a typeglob here. A reference to a typeglob is okay though.
open (my $fileb, ">", \$response_body);
open (my $fileheader, ">", \$response_header);
$curl->setopt(CURLOPT_URL, 'http://example.com');
$curl->setopt(CURLOPT_WRITEDATA,$fileb);
$curl->setopt(CURLOPT_WRITEHEADER,$fileheader);


# Starts the actual request
my $retcode = $curl->perform;

# Looking at the results...
if ($retcode == 0) {
  print("Transfer went ok\n");
  my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
  # judge result and next action based on $response_code
  print("Received header: $response_header\n");
  print("Received body: $response_body\n");
} else {
  print("An error happened: ".$curl->strerror($retcode)." ($retcode)\n");
}


