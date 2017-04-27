#!/usr/bin/perl
use CGI;
my $cgi = CGI->new();
my $pattern = $cgi->param("regex");
my $flags = $cgi->param("flags");
my $other_data =$cgi->param("html_data"); 
print "Content-type: text/html\n\n";
open my $wh, ">" , "test.txt";
print $wh $other_data;
$flags =~s/\n//g;
$pattern =~s/\n//g;
#replace < by &lt; and > by &gt;
my @color = ("#fafafa","#EEE9BF", "#EED5D2", "#FBA3F6", "#B4EEB4", "#FFF68F", "#EEE0E5", "#EEEED1", "#FFD39B", "#EEAEEE", "#EEE8CD");
if($flags =~m/g/)
{	
	$pre_compile = qr((?^$flags)$pattern);
	my $K = 1;
	our $LINE = 1;
	
	while($other_data =~m/$pre_compile/g)
	{
		my $matched_data_dum = $&;
		my $matched_data = $matched_data_dum;
		$matched_data_dum=~s/</&lt;/ig;
		$matched_data_dum=~s/>/&gt;/ig;
		print  "<br><span style='background:skyblue'>Full match ($K)</span>";
		print "<pre>$matched_data_dum</pre>";
		
		$LINE+=1;
		
		our @group = $matched_data =~m/$pre_compile/g;
		if($pattern=~m/.\(/is)
		{
			&match_looping();
		}
		$K++;
		print "\n";
		$LINE+=2;
	}
	#print "HUSSAINBOXER_TOTAL_MATCH_$K";
}
else
{
	
	my $pre_compile = qr((?$flags)$pattern);
	our @group = $other_data =~m/$pre_compile/;
	my $matched_data_dum = $&;
	my $matched_data = $matched_data_dum;
	$matched_data_dum=~s/</&lt;/ig;
	$matched_data_dum=~s/>/&gt;/ig;
	print  "<span style='background:skyblue'>Full match</span>";
	print "<pre>$matched_data_dum</pre><br>";
	if($pattern=~m/.\(/is)
	{
		&match_looping();
	}
	#print "\n";
	#print "HUSSAINBOXER_TOTAL_MATCH_1";
}


sub match_looping
{

	my $J = 1;
	my $Val = scalar @group;
	foreach (@group)
	{
		print "<span style='background:$color[$J];'>Group $J </span>\n";
		s/</&lt;/igs;
		s/>/&gt;/igs;
		print "<pre>$_</pre>";	
		#if ($J < $Val)
		#{
		$LINE+=3;
		my $str_len = length ($_);
		
		#}
		$J++;
	}
	
	$LINE+=2;

}
