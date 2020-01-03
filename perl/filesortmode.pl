use Encode qw/encode decode/;
use v5.10.1;
no warnings 'experimental';

our %SIZENAME = ('B'=>0, 'KB'=>10,'MB'=>20,'GB'=>30, 'TB'=>40, 'PB'=>50);
our @BYTENAME = ('B','KB','MB','GB','TB','PB');
our @UNITNAME = ('year','month','day','hour','minite','second');

sub extension
{
    my($filelist) = $_[0];
    for my $pref (keys %$filelist){
	if($pref =~ /(([a-zA-Z0-9]|\w|\s)*)\.(.+)$/){
	    $filelist->{$pref} = $filelist->{$pref}."/$3";
	}
	elsif($files =~ /(.*)$/){
    	    $filelist->{$pref} = $filelist->{$pref}."/noextension";
	}
    }
    return $filelist;
}

sub size
{
    my($filelist) = $_[0];
    my ($filesize,$interres,$smode,$inter,$size);
    $size = decode('UTF-8',$SIZEINTERVAL) || $DEFAULTSETTING{'SIZEINTERVAL'};
    if($size eq '//each time//'){
	print("interval size(ex:10KB)>>");
	chomp($size = <STDIN>);
    }
    if($size =~ /((\d)+)(([a-zA-Z])+)/){
	$smode = uc($3);
	$inter = $1;
    }
    cprint(36,"size of interval(size mode): ","$inter$smode\n");
    unless($smode =~ /^(B|KB|MB|GB|TB|PB)$/i){cprint(1,"undefined byte mode\n"); exit(0);}
    if($inter==0){cprint(1,"can't divide 0\n"); exit(0);}
    for my $pref (keys %$filelist){
	$filesize = (-s $pref) >> $sizename{$smode};
	$interres = $inter;
	$interres+=$inter while $filesize/$interres > 1.0;
	$filelist->{$pref} = $filelist->{$pref}."/$interres$smode";
    }
    return $filelist;
}	

sub date
{
    my($filelist) = $_[0];
    my ($datedir,$smode,@st,@unitlist);
    $smode = decode('UTF-8',$WHICHDATE) || $DEFAULTSETTING{'WHICHDATE'};
    if($smode eq '//each time//'){
	print "which mode(1:create date 2:last update date)\n>>";
	chomp($smode = <STDIN>);
    }
    if($smode==1){cprint(36,"which date mode(date mode): ","create date\n");}
    elsif($smode==2){cprint(36,"which date mode(date mode): ","last update date\n");}
    else{cprint(1,"undefined datemode\n");exit(0);}
    my $unit=decode('UTF-8',$DATEUNITS) || $DEFAULTSETTING{'DATEUNITS'};
    if($unit eq '//each time//'){
	print "units(1:year 2:mon 3:day 4:hour 5:min 6:sec)(ex:123)>>";
	chomp($unit = <STDIN>);
    }
    my @unitlist;
    foreach(split //, $unit){
	if($_>=1 && $_<=6){push(@unitlist,"$UNITNAME[$_-1]");}
	else{cprint(1,"undefined unitmode\n");exit(0);}
    }
    my $unitdisp= join('-',@unitlist);
    cprint(36,"date units(date mode): ","$unitdisp\n");
    for my $pref (keys %$filelist){
	@unitlist=();
	@st =(localtime((stat("$pref"))[8+$smode]))[0..5];$st[5]+=1900;$st[4]++;
	foreach(split //, $unit){push(@unitlist,$st[6-$_]);}
	$unitdisp= join('-',@unitlist);
	if($smode==1){$unitdisp = 'mk'.$unitdisp;}
	elsif($smode==2){$unitdisp = 'lu'.$unitdisp;}
	$filelist->{$pref} = $filelist->{$pref}."/$unitdisp";
    }
    return $filelist;
}

sub list
{
    my(@s1,@s2,$tmp1,$tmp2,$st1,$st2);
    my($filelist,$indir) = @_;
    my($filesize,$mode,$listdir);
    my $unit=decode('UTF-8',$LISTDATEUNITS) || $DEFAULTSETTING{'LISTDATEUNITS'};
    if($unit eq '//each time//'){
	print "date units(1:year 2:mon 3:day 4:hour 5:min 6:sec)(ex:123)>>";
	chomp($unit = <STDIN>);
    }
    my @unitlist;
    foreach(split //, $unit){
	if($_>=1 && $_<=6){push(@unitlist,"$UNITNAME[$_-1]");}
	else{cprint(1,"undefined unitmode\n");exit(0);}
    }
    my $unitdisp= join('-',@unitlist);
    cprint(36,"date units(filelist mode): ","$unitdisp\n\n");
    cprint(75747372767,"[","name","]\t:\t[","ext","]\t:\t[","size","]\t:\t[","create","]\t:\t[","last update","]\n--------------------------------------------\n");
    for my $pref (keys %$filelist){
	$filesize = -s $pref;
	$mode = 0;
	foreach(split //, $unit){
	    $tmp1 =(localtime((stat("$pref"))[9]))[6-$_];
	    $tmp2 =(localtime((stat("$pref"))[10]))[6-$_];
	    $tmp1+=1900 if $_==1;$tmp1++ if $_==1;
	    $tmp2+=1900 if $_==1;$tmp2++ if $_==1;
	    push(@s1, $tmp1);
	    push(@s2, $tmp2);
	}
	$st1 = join('-',@s1);$st2 = join('-',@s2);
	while(($filesize >> 10) > 1.0){$filesize = $filesize >> 10;$mode++;}
	$pref = substr($pref, length($indir)+1,length($pref));
	if($pref=~ /(.*)\.(.+)$/){
   	    cprint(76727375747,"[","$1","]\t:\t[","$2","]\t:\t[","$filesize$BYTENAME[$mode]","]\t:\t[","$st1","]\t:\t[","$st2","]\n");
	}
	elsif($pref =~ /(.*)\/(([^\/])*)$/){
	    cprint(76727375747,"[","$2","]\t:\t[","---","]\t:\t[","$filesize$BYTENAME[$mode]","]\t:\t[","$st1","]\t:\t[","$st2","]\n");
	}
	@s1=();@s2=();
    }
    cprint(7,"--------------------------------------------\n\n");
}

sub conflist
{
    my $confdir = Cwd::getcwd();
    cprint(757,"\n[","$confdir/config.txt","]\n--------------------------------------------\n");

    my(@elista,@elistb,@elist);
    @elista=("select mode                : ",
	     "place of  input directory  : ",
	     "place of output directory  : ",
	     "size of interval(size mode): ",
	     "which date mode(date mode) : ",
	     "date units(date mode)      : ",
	     "date units(filelist mode)  : ",
	     "file command(1:copy 2:move): ",
	     "make log file(y/n)         : ",
	     "date units(result folder)  : ");
    @elistb=($SELECTMODE,$INPUTDIRECTORY,$OUTPUTDIRECTORY,$SIZEINTERVAL,$WHICHDATE,$DATEUNITS,$LISTDATEUNITS,$FILECOMMAND,$LOGFILE,$RESULTTIMEUNITS);
    
    for(0..9){cprint(366,$elista[$_],$elistb[$_],"\n");}
    cprint(7,"--------------------------------------------\n\n\n");

    @elistb=();
    my $e0b=decode('UTF-8',$SELECTMODE) || $DEFAULTSETTING{'SELECTMODE'};
    my ($j,$k,$l)=(0,0,0);
    my $e0 = $e0b;
    if($e0b ne '//each time//')
    {
	if($e0b>=0){while($e0b =~ /^([0-9])(.*)/){push(@elist, $1);$e0b=$2;}}
	else{$l++;}
	for $e0b(@elist){
	    given($e0b){
		when(1){if($k==0){$j++;}else{$l++;}push(@elistb,'extension');}
		when(2){if($k==0){$j++;}else{$l++;}push(@elistb,'size');}
		when(3){if($k==0){$j++;}else{$l++;}push(@elistb,'date');}
		when(4){if($j==0){$j++;$k++;}else{$l++;}push(@elistb,'filelist');}
		when(5){if($j==0){$j++;$k++;}else{$l++;}push(@elistb,'configlist');}
		when(9){if($j==0){$j++;$k++;}else{$l++;}push(@elistb,'quit');}
		default{$l++;push(@elistb,'{undifined}');}
	    }
	}
    }
    $e0b = join('-',@elistb);
    $e0b=$e0 if ($e0 eq '//each time//');
    $e0 = "$e0b($e0)";
    if($l!=0){$e0="<ERROR>:$e0";}
    if($e0 eq '//each time//(//each time//)'){$e0 = $DEFAULTSETTING{'SELECTMODE'};}    
    my $e1=decode('UTF-8',$INPUTDIRECTORY) || $DEFAULTSETTING{'INPUTDIRECTORY'};
    if($e1 ne '//each time//'){$e1 =~ s/\/\//\//g;$e1="<ERROR>($e1)"  unless (-d $e1);}
    my $e2=decode('UTF-8',$OUTPUTDIRECTORY) || $DEFAULTSETTING{'OUTPUTDIRECTORY'};
    if($e2 ne '//each time//'){$e2 =~ s/\/\//\//g;$e2="<ERROR>($e2)"  unless (-d $e2);}
    my $e3=uc(decode('UTF-8',$SIZEINTERVAL) || $DEFAULTSETTING{'SIZEINTERVAL'});
    if($e3 ne '//EACH TIME//'){$e3 = "<ERROR>($e3)" unless ($e3 =~ /^((\d)+)(B|KB|MB|GB|TB|PB)$/);}
    else{$e3='//each time//';}
    my $e4=decode('UTF-8',$WHICHDATE) || $DEFAULTSETTING{'WHICHDATE'};
    if($e4 ne '//each time//'){
	$e4 = "<ERROR>($e4)" unless ($e4==1||$e4==2);
	$e4 = "create date($e4)" if $e4==1;
	$e4 = "last update date($e4)" if $e4==1;
    }
    my $e5=decode('UTF-8',$DATEUNITS) || $DEFAULTSETTING{'DATEUNITS'};
    my $e6=decode('UTF-8',$LISTDATEUNITS) || $DEFAULTSETTING{'LISTDATEUNITS'};
    my $e7=decode('UTF-8',$FILECOMMAND) || $DEFAULTSETTING{'FILECOMMAND'};
    if($e7==1){$e7="copy($e7)";}elsif($e7==2){$e7="move($e7)";}elsif($e7 eq '//each time//'){}else{$e7="<ERROR>($e7)";}
    my $e8=decode('UTF-8',$LOGFILE) || $DEFAULTSETTING{'LOGFILE'};
    if($e8 eq 'y'){$e8="yes($e8)";}elsif($e8 eq 'n'){$e8="no($e8)";}elsif($e8 eq '//each time//'){}else{$e8="<ERROR>($e8)";}
    my $e9=decode('UTF-8',$RESULTTIMEUNITS) || $DEFAULTSETTING{'RESULTTIMEUNITS'};
    my @e569=($e5,$e6,$e9);my $et;
    for(@e569){
	@elist=();
	if($_ ne '//each time//'){
	    foreach(split //, $_){
		if($_>=1 && $_<=6){push(@elist,"$UNITNAME[$_-1]");}
		else{push(@elist,'<ERROR>');}
	    }
	    $et= join('-',@elist);
	    $_ = "$et($_)";
	}
    }
    ($e5,$e6,$e9)=@e569;
    my @elistb= ($e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9);
    
    cprint(757,"[","RESULT SETTING","]\n--------------------------------------------\n");
    for(0..9){
	if($_==0&&($elistb[$_] eq 'filelist(4)'||$elistb[$_] eq 'configlist(5)')){cprint(327,$elista[$_],$elistb[$_],"\n");}
	elsif($elistb[$_] !~ /<ERROR>/){cprint(367,$elista[$_],$elistb[$_],"\n");}
	else{cprint(317,$elista[$_],$elistb[$_],"\n");}
    }
    cprint(7,"--------------------------------------------\n\n");
}

sub quit{exit(0);}

1;
