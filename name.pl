#!/usr/bin/perl
use strict;
use warnings;

my $baseurl = 'http://export.arxiv.org/api/query?id_list=';

sub usage {
  print $0 . " :: requires one argument, the arXiv id.\n";
  exit 1;
}

if ($#ARGV eq -1 ) {
  usage();
}

my $id = $ARGV[0];
my $outfile = $id . '.tmp';
my $re1 = '.*</name>';
my $re2 = '</name>';

system 'curl -s -X GET ' . $baseurl . $id . ' -o ' . $outfile;
my $cont = do { local (@ARGV, $/) = $outfile; <> };
my $strip = $cont =~ s/\n//g;
my @list = split / /, $cont;

my @auth = grep { $_ =~ /$re1/ } @list;
my $name = join '-', @auth, $id;
$name =~ s/$re2//g;
my $ret = $name . '.pdf';

print $ret;

system 'rm ' . $outfile;

