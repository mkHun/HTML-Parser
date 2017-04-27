#!/usr/bin/perl
use CGI;
use warnings;
use strict;
my $cgi = CGI->new();
my $tagname = $cgi->param("tagname");
my $attr = $cgi->param("attr");
my $attrname = $cgi->param("attrname");
my $cont =$cgi->param("html_data"); 
my $parse_method = $cgi->param("parse_method");

print "Content-type: text/html\n\n";

if($parse_method eq "parse")
{
	my $result = parse({"tag"=>$tagname,"attr"=>$attr,"attrname"=>$attrname,"cont"=>\$cont});
	print $result;

	sub parse
	{
		my %hash = %{shift @_};
		my $tag = $hash{tag};
		my $ref = $hash{cont};

		my $cont_val = $$ref;

		my $frame_tag = "<$hash{tag}"."[^>]*$hash{attr}="."[\"']$hash{attrname}"."['\"][^>]*>";
		return "" unless($cont_val=~m/$frame_tag/is);
		my $new_cont = substr($cont_val,$-[0]);
		my @ar = split(/<[^>]*>\K/,$new_cont);
		my $i = 0;
		my $tag_cont;
		foreach my $ech_lines(@ar)
		{
			$i++ if($ech_lines =~m/<$tag\s*[^>]*>/i);
			$i-- if($ech_lines =~m/<\/$tag\s*[^>]*>/is);
			$tag_cont .= $ech_lines;
			last if($i == 0  && $ech_lines=~m/<\/$tag\s*[^>]*>/is)
		}
		return $tag_cont;
	}
}
else
{
	
	my $cont_for_parse = $cont;
	my $total_number;
	
	foreach (;;)
	{
		my $parse_cont =  parse_all({"tag"=>$tagname,"attr"=>$attr,"attrname"=>$attrname});
		
		last if($parse_cont eq "");
		print $parse_cont;	
		$total_number++;
	}
	print "END#!#!$total_number";
	sub parse_all
	{

		my %hash = %{shift @_};
		my $tag = $hash{tag};
		my $ref = $hash{cont};
		my $frame_tag = "<$hash{tag}"."[^>]*$hash{attr}="."[\"']$hash{attrname}"."['\"][^>]*>";
		return "" unless($cont_for_parse=~m/$frame_tag/is);
		my $new_cont = substr($cont_for_parse,$-[0]);
		substr($cont_for_parse,0,$-[0]) = "";
		my @ar = split(/<[^>]*>\K/,$new_cont);
		my $i = 0;
		my $tag_cont;
		foreach my $ech_lines(@ar)
		{
			$i++ if($ech_lines =~m/<$tag\s*[^>]*>/i);
			$i-- if($ech_lines =~m/<\/$tag\s*[^>]*>/is);
			$tag_cont .= $ech_lines;
			last if($i == 0  && $ech_lines=~m/<\/$tag\s*[^>]*>/is);
		}
		substr($cont_for_parse,0,length($tag_cont)) = "";
		return $tag_cont;
	}
}



