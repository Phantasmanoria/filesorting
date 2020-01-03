#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Cwd;
use Term::ANSIColor;
use v5.10.1;
no warnings 'experimental';

our $TIME;
our $SELECTMODE;
our $INPUTDIRECTORY;
our $OUTPUTDIRECTORY;
our $SIZEINTERVAL;
our $WHICHDATE;
our $DATEUNITS;
our $LISTDATEUNITS;
our $FILECOMMAND;
our $LOGFILE;
our $RESULTTIMEUNITS;
our @COLORCODE =('black','red','green','yellow','blue','magenta','cyan','white','reset');
our %DEFAULTSETTING = (
    'SELECTMODE'      => '//each time//', 
    'INPUTDIRECTORY'  => "$ENV{'HOME'}/classification",
    'OUTPUTDIRECTORY' => Cwd::getcwd(),
    'SIZEINTERVAL'    => '//each time//',
    'WHICHDATE'       => '//each time//',
    'DATEUNITS'       => 123,
    'LISTDATEUNITS'   => 123,
    'FILECOMMAND'     => 1,
    'LOGFILE'         => 'y',
    'RESULTTIMEUNITS' => 23456);


require './filesortmode.pl';
require './filesortdir.pl';
makeconfig() unless -r './config.txt';
require './config.txt';


checkconfig();
my $indir= inputdir();
my $outdir = outputdir();
my $filedir = setupfiles($indir);
my $fileanddir = setupfiles2($outdir,$filedir);

my $mode=decode('UTF-8',$SELECTMODE) || $DEFAULTSETTING{'SELECTMODE'};
my $mode2=$mode;
if($mode eq '//each time//'){
    print "Select sortmode(1:extension 2:size 3:date 4:filelist 5:configlist 9:quit)\nyou can select some 1~3 mode recursively(example:12)\n>>";
    chomp($mode = <STDIN>);
}

my @modelist;
my ($j,$k,$l)=(0,0,0);
my @name;
if($mode>=0){
    while($mode =~ /^([0-9])(.*)/){push(@modelist, $1);$mode=$2;}
}
else{$l++;}

for $mode(@modelist){
    given($mode){
	when(1){if($k==0){$j++;push(@name, 'extension');}else{$l++;}}
	when(2){if($k==0){$j++;push(@name, 'size');}else{$l++;}}
	when(3){if($k==0){$j++;push(@name, 'date');}else{$l++;}}
	when(4){if($j==0){$j++;push(@name, 'filelist');$k++;}else{$l++;}}
	when(5){if($j==0){$j++;push(@name, 'configlist');$k++;}else{$l++;}}
	when(9){if($j==0){$j++;push(@name, 'quit');$k++;}else{$l++;}}
	default{$l++;}
    }
}
if($l!=0){
    if($mode2 ne '//each time//'){
	cprint(13,"exceptional sortmode.Please check config.txt\n","run conflist mode.\n");
	conflist();exit(0);
    }
    else{
	cprint(1,"exceptional sortmode\n");exit(0);
    }
}
$l = join('-',@name);
cprint(36,"select mode:","$l\n");

for $mode(@modelist){
    given($mode){
	when(1){$fileanddir = extension($fileanddir);}
	when(2){$fileanddir = size($fileanddir);}
	when(3){$fileanddir = date($fileanddir);}
	when(4){list($fileanddir,$indir);}
	when(5){conflist();}
	when(9){quit();}
	default{cprint(1,"exceptional error\n");exit(0);}
    }
}

if($j!=0&&$k==0){
    cpormv($fileanddir,$indir,$outdir);
    cprint(2,"classification completed.\n");
}
exit(0);

