use open IO => ":utf8";
use Encode::Guess;
use File::Copy;
use File::Path;
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";




sub inputdir
{
    my $directory=decode('UTF-8',$INPUTDIRECTORY) || $DEFAULTSETTING{'INPUTDIRECTORY'};
    if($directory eq '//each time//'){
	print "input directory>>";
	chomp($directory = <STDIN>);
    }
    $directory =~ s/\/\//\//g;
    unless(-d $directory){cprint(161,"input directory[","$directory","] is unavailable.\n");exit(0);}
    cprint(36,"input  directory: ","$directory.\n");
    return $directory;
}

sub outputdir
{
    my $directory=decode('UTF-8',$OUTPUTDIRECTORY) || $DEFAULTSETTING{'OUTPUTDIRECTORY'};
    if($directory eq '//each time//'){
	print "output directory>>";
    chomp($directory = <STDIN>);
    }
    $directory =~ s/\/\//\//g;
    unless(-d $directory){cprint(161,"output directory[","$directory","] is unavailable.\n");exit(0);}
    cprint(36,"output directory: ","$directory.\n");
    $directory = $directory."/result[$TIME]";
    return $directory;
}

sub setupfiles
{
    my ($nowdir) = $_[0];
    my @all_filesb = glob "$nowdir/*";
    my @all_filesa;
    foreach my $files(@all_filesb){
	$files = decode('UTF-8',$files);
	if (-d $files){
	    $tmp = setupfiles($files);
	    push(@all_filesa, @$tmp);
	}
	else{
	    push(@all_filesa, $files);
	}
    }
    return \@all_filesa;
}

sub setupfiles2
{
    my ($outd, $all_files) = @_;
    my %allfilelist;
    foreach my $files(@$all_files){
	$all_filelist{$files} = $outd;
    }
    return \%all_filelist;
}

sub cpormv
{
    my($filelist,$in,$out) = @_;
    my $mode = decode('UTF-8',$FILECOMMAND) || $DEFAULTSETTING{'FILECOMMAND'};
    my $log = decode('UTF-8',$LOGFILE) || $DEFAULTSETTING{'LOGFILE'};
    if($mode eq '//each time//'){
	print("file command(1:copy(recommend) 2:move)\n>>");
	chomp($mode = <STDIN>);
    }
    if($log eq '//each time//'){
	print("make log?(y/n)>>");
	chomp($log = <STDIN>);
    }
    unless($log eq 'y'||$log eq 'n'){cprint(1,"log error\n");exit(0);}
    if($log eq "y"){
	mkpath("$out");
	open(LOG,">","$out/log.txt") or die cprint(1,"openlog error\n");
    }

    my $filename;
    
    if($mode==1){
	cprint(36,"file command: ","copy\n");
	print LOG "file option : copy\n---------------------\n\n" if $log eq "y";
	for my $pref (keys %$filelist){
	    mkpath($filelist->{$pref});
	    copy($pref, $filelist->{$pref});
	    $filename=$1 if ($pref =~ /\/([^\/]*)$/);
	    print LOG "[$pref] >> [$filelist->{$pref}\/$filename]\n" if $log eq "y";
	}
    }
    elsif($mode==2){
	cprint(36,"file command: ","move\n");
	print LOG "file option : move\n---------------------\n\n" if $log eq "y";
	for my $pref (keys %$filelist){
	    mkpath($filelist->{$pref});
	    move($pref, $filelist->{$pref});
	    $filename=$1 if ($pref =~ /\/([^\/]*)$/);
	    print LOG "[$pref] >> [$filelist->{$pref}\/$filename]\n" if $log eq "y";
	}
    }
    else{
	cprint(1,"file command error\n");
	if($log eq "y"){
	    print LOG "exception error:stopped in process\n[$pref] >> [$filelist->{$pref}]";
	    close(LOG);
	}
	exit(0);
    }
    if($log eq "y"){
	print LOG "\n---------------------\nprocess finished.\n";
	close(LOG);
	cprint(3,"make logfile\n");
    }
}

sub makeconfig
{
    open(CONF,">",'config.txt');
    print CONF "#select mode(1:extension 2:size 3:date 4:filelist 5:configlist 9:quit)(default://each time//)\n";
    print CONF "\$SELECTMODE=\'\'\;\n";
    print CONF "\n";
    print CONF "#place of input directory(default:\$HOME/classification/)\n";
    print CONF "\$INPUTDIRECTORY=\'\'\;\n";
    print CONF "\n";
    print CONF "#place of output directory(default:same directory filesort)\n";
    print CONF "\$OUTPUTDIRECTORY=\'\'\;\n";
    print CONF "\n";
    print CONF "#size of interval(size mode)(default://each time//)\n";
    print CONF "\$SIZEINTERVAL=\'\'\;\n";
    print CONF "\n";
    print CONF "#which date mode(date mode)(1:create date 2:last update date)(default://each time//)\n";
    print CONF "\$WHICHDATE=\'\'\;\n";
    print CONF "\n";
    print CONF "#date units(date mode)(1:year 2:mon 3:day 4:hour 5:min 6:sec)(default:123)\n";
    print CONF "\$DATEUNITS=\'\'\;\n";
    print CONF "\n";
    print CONF "#date units(filelist mode)(1:year 2:mon 3:day 4:hour 5:min 6:sec)(default:123)\n";
    print CONF "\$LISTDATEUNITS=\'\'\;\n";
    print CONF "\n";
    print CONF "#file command(1:copy(recommend) 2:move)(default:1)\n";
    print CONF "\$FILECOMMAND=\'\'\;\n";
    print CONF "\n";
    print CONF "#make log file(y/n)(default:y)\n";
    print CONF "\$LOGFILE=\'\'\;\n";
    print CONF "\n";
    print CONF "#date units(result folder)(1:year 2:mon 3:day 4:hour 5:min 6:sec)(default:23456)\n";
    print CONF "\$RESULTTIMEUNITS=\'\'\;\n";
    print CONF "\n";
    print CONF "\n";
    print CONF "\n";
    print CONF "\n";
    print CONF "\n";
    print CONF "1\;\n";
    close(CONF);
    cprint(3,"make config.txt\n");
}

sub checkconfig
{
    my $mode=decode('UTF-8',$SELECTMODE) || $DEFAULTSETTING{'SELECTMODE'};
    my $mode2=$mode;my $ans;
    if($mode ne '//each time//'){
	if($mode==4){
	    cprint(386838,"\$SELECTMODE in config.txt"," is ","$mode",".\nYou really select ","filelist mode","?(y/n)(default:n)>>");
	    chomp($ans = <STDIN>);
	    $ans = $ans || 'n';
	    if($ans ne 'y'){$SELECTMODE='';}
	}
	if($mode==5){
	     cprint(386838,"\$SELECTMODE in config.txt"," is ","$mode",".\nYou really select ","configlist mode","?(y/n)(default:n)>>");
	    chomp($ans = <STDIN>);
	    $ans = $ans || 'n';
	    if($ans eq 'y'){conflist();exit(0);}
	    else{$SELECTMODE='';}
	}
	if($mode==9){
	     cprint(386838,"\$SELECTMODE in config.txt"," is ","$mode",".\nYou really ","quit this process?","(y/n)(default:n)>>");
	    chomp($ans = <STDIN>);
	    $ans = $ans || 'n';
	    if($ans eq 'y'){cprint(2,"process is finished.\n");
	    quit();
	    }
	    else{$SELECTMODE='';}
	}
    }

    $mode=decode('UTF-8',$RESULTTIMEUNITS) || $DEFAULTSETTING{'RESULTTIMEUNITS'};
    $mode2=$mode;
    if($mode eq '//each time//'){
	print "time units in result folder(1:year 2:mon 3:day 4:hour 5:min 6:sec)(ex:123)>>";
	chomp($mode = <STDIN>);
    }

    my (@unitlist,@timelist);
    foreach(split //, $mode){
	if($_>=1 && $_<=6){
	    push(@unitlist,"$UNITNAME[$_-1]");
	    if($_==1){push(@timelist,(localtime(time))[6-$_]+1900);}
	    elsif($_==2){push(@timelist,(localtime(time))[6-$_]+1);}
	    else{push(@timelist,(localtime(time))[6-$_]);}
	}
	else{
	    cprint(1,"undefined result time unit\n");   
	    if($mode2 ne '//each time//'){
		cprint(13,"Please check config.txt\n","run conflist mode.");
		conflist();
	    }
	    exit(0);
	}
    }
    my $unitdisp= join('-',@unitlist);
    $TIME = join('-',@timelist);
    cprint(36,"date units(result folder): ","$unitdisp\n");
    
}

sub cprint
{
    my @tmp= @_;my $number=$tmp[0];
    my (@colornumber,@word,@result,$resultword);
    for(1..$#tmp){push(@word, $tmp[$_]);}
    if($number>=0){while($number =~ /^([0-9])(.*)/){push(@colornumber, $COLORCODE[$1]);$number=$2;}}
    
    if($#colornumber!=$#word){print"error\n";exit(0);}
    for(0..$#word){print color('reset').color("$colornumber[$_]")."$word[$_]";}
    print color('reset');
}

1;
