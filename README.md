# filesorting

完結に書くと**自動でファイルを指定した条件で再帰的に分類してくれるソフト**.  
『デスクトップやダウンロードの中がいろんなファイルでぐちゃぐちゃ...』という状態を解決するために作成. 設定ファイルで予め行う内容も決められる上にオプション指定にも対応している.  
Perl版とRuby版があるが, Perl版をもう一度作り直したのがRuby版. 今回の主役は**Ruby版**とする.  

## Perl版

まだリファクタリングとか何も知らない時に作ったすごい汚いコード.  
汚すぎて書き直す気が起きないくらいにはスパゲッティーコードしてる.  
ていうかコメント書かなさすぎてそもそもわけわからない事態になってる.  
比較の対象とするためにここに残す.  
Perl版のREADMEは[こちら](https://github.com/Phantasmanoria/filesorting/blob/master/perl/guide.txt)を参照.  

## Ruby版

## 内容

上記のPerl版のものをRubyで作り直したもの.  
同時にコードや動作の視認性, コメント追加, オプションの改善, 動作の改善も行った.  
動作にはRubyライブラリの[colorize](https://github.com/fazibear/colorize)が必要.  

## 実行環境

```sh
%cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.2 LTS"
%ruby --version
ruby 2.5.3p105 (2018-10-18 revision 65156) [x86_64-linux]
```

## インストール・実行方法

```sh
%git clone git@github.com:Phantasmanoria/filesorting.git
%cd filesorting/ruby
%ruby run.rb --init # 初期化
%ruby run.rb # 実行
```

## オプション一覧

```sh
%ruby run.rb --help
load options.
Usage: run [options]
    -c [MODE, MODE...]               classification (EXT,SIZE,DATE(e.g. EXT,DATE))(default:NONE)
    -d [UNIT]                        date in -c = DATE(YEAR|MONTH|DAY|HOUR|MINUTE|NONE) (default:NONE)
    -f [FILE]                        config file (default:config.yml)
    -i [FOLDER, FOLDER, ..]          input folders (default:./in)
    -l                               log output(default:false)
    -m [MODE]                        mode (SORT|LIST|CONF|NONE) (default:NONE)
    -o [FOLDER]                      output folder (default:./out)
    -s [STRING]                      size interval in -c = SIZE(e.g. 24KB)(default:NONE)
        --mv                         file cp -> file mv (default:false)
        --init                       reset all settings (default:off)
```
オプションの読み込みは**オプション指定 > 設定ファイル > 初期値**の優先度で行われる.  

### 分類オプション(-c)

分類を行う時の分類方法を予め指定することが出来る. 初期値は`NONE`.  
入力候補は`EXT`,`SIZE`,`DATE`,`NONE`を1つ, または2つ以上を`,`で繋げて指定が出来る.  
`EXT`は拡張子,`SIZE`はファイルサイズ,`DATE`は最終更新日時,`NONE`は無指定を示している.  
指定を複数行った時, フォルダ分類を再帰的に行える(例を挙げると, `EXT,DATE`とすると, 
拡張子分類をした中で更に最終更新日時分類が行われる).  
複数指定してもその中に`NONE`が含まれていたら強制的に`NONE`への変更が行われる.  
`NONE`を指定すると, このオプションが必要な時に改めて指定が行える.  


### 日時単位オプション(-d)

最終更新日時分類を行う時の分類単位を予め指定することが出来る. 初期値は`NONE`.  
入力候補は`YEAR`,`MONTH`,`DAY`,`MINUTE`,`NONE`のうちのどれかを選択できる.  
指定を行うと, その指定された単位の時間までで分類が行われる(例を挙げると, `DAY`とすると, 
`YEAR`,`MONTH`,`DAY`までの内容で最終更新日時分類が行われる).  
`NONE`を指定すると, このオプションが必要な時に改めて指定が行える.  


### 設定ファイルオプション(-f)

読み込む設定ファイルを指定することが出来る. 初期値は同ディレクトリの`config.yml`.  
ここで指定したファイルが存在しない時, 自動的に`config.yml`に変更が行われる.  
`config.yml`も存在しなかった時は作成動作が行われる.  


### 読み込みディレクトリオプション(-i)

ファイル分類を行うディレクトリを指定することが出来る. 初期値は同ディレクトリの`in`.  
ここでは複数のディレクトリの指定が行える. その場合は`,`で繋げて記述する.  


### ログ出力オプション(-l)

ログの出力をするかしないかを指定できる. 初期値は`false(実行しない)`.  
ログの出力を行いたい場合は`-l`を追加するのみで行える.  
ログの出力内容はMODE選択時から先の全ての標準出力になっている.  
ログの出力場所は同ディレクトリの`out(無かった場合は自動生成)`内の`(実行日時).log`.  
ログの確認は`cat`コマンドで実行すると, 色の出力も行えるのでわかりやすい.  


### モードオプション(-m)

このプログラムの実行モードを予め指定することが出来る. 初期値は`NONE`.  
入力候補は`SORT`,`LIST`,`CONF`,`QUIT`のうちのどれかを選択できる.  
`SORT`は分類モード,`LIST`は分類候補のファイル一覧表示,`CONF`は設定の表示,`QUIT`は終了を示している.  
`NONE`を指定すると, このオプションが必要な時に改めて指定が行える.  


### 書き出しディレクトリオプション(-o)

ファイル分類後の結果を入れるディレクトリを指定することが出来る. 初期値は同ディレクトリの`out`.  
`-i`の読み込みディレクトリオプションとは異なり, 複数の指定は行えない.  
また, `-i`の読み込みディレクトリと同一パスの指定も行えないので注意.  


### サイズ単位オプション(-s)

ファイルサイズ分類を行う時の分割する単位を予め指定することが出来る. 初期値は`NONE`.  
入力は`20KB`や`4MB`のように, **数字(1から999)と単位(BからPBまで)**のようにすること.  
指定を行うと, 指定された分割単位でファイルサイズ分類が行われる(例を挙げると, `20KB`とすると, 
`20KB`,`40KB`,`60KB`,...のようにファイルサイズ分類が行われる).  
`NONE`を指定すると, このオプションが必要な時に改めて指定が行える.  


### 移動オプション(--mv)

ファイルの分類を行う時, 元ファイルの扱いをコピーから移動に変更できる. 初期値は`false(実行しない)`.  
変更を行いたい場合は`--mv`を追加するのみで行える.  
ファイルの扱いを標準でコピーにしているのは, 強制終了発生等の時の保険を用意するためなので, 
このオプションをつける時はそのことを了承の上で実行すること.  


### 初期化オプション(--init)

初期設定ファイルの作成, 初期入力出力ディレクトリの作成等の初期化ができる. 初期値は`false(実行しない)`.  
変更を行いたい場合は`--init`を追加するのみで行える.  
既に初期設定ファイル`config.yml`が存在している場合は上書きされてしまうので, 
このオプションをつける時はそのことを了承の上で実行すること.  



## 使い方 モード選択(初期設定時)

初期設定で実行すると最初はモードの選択を行う必要がある.  
使いたいモードに対応した数字を入力を行うと, 該当するモードを実行できる.  

```sh
load options.
load config file.
check options.
load input files.
select mode! (1:SORT, 2:LIST, 3:CONF, 4:QUIT)
>>
```

### 分類モード(SORT)

このプログラムの一番の機能であるファイルの分類を実行する. 詳細は下記を参照すること.  


### 分類候補一覧モード(LIST)

```sh
START LIST MODE!
FILE LIST
--------------------------------------------------------------------------------------
|path                                    |size  |ext       |modify time        |
--------------------------------------------------------------------------------------
|~s/git/filesorting/ruby/in/adjskadfj.txt|  0  B|       txt|2020/01/06 17:11:49|
|~ers/git/filesorting/ruby/in/ajaj.tar.gz|  0  B|    tar.gz|2020/01/04 13:24:11|
|~sers/git/filesorting/ruby/in/ajkasdhsdf|  0  B|      NONE|2019/12/30 11:06:57|
|~me/users/git/filesorting/ruby/in/asdklf|  0  B|      NONE|2020/01/06 11:56:52|
|/home/users/git/filesorting/ruby/in/udhd|175 KB|      NONE|2020/01/06 11:57:28|
|~ome/users/git/filesorting/ruby/in/asdds|  0  B|      NONE|2020/01/06 11:56:54|
--------------------------------------------------------------------------------------
```

このプログラムで分類される候補と認識しているファイルを一覧で確認できる.  
ファイルのパスと, 今回の分類で使われる要素のみを表示している.  
また, 拡張子(ext)が無いものについては`NONE`と表記される.  


### 設定一覧モード(CONF)

```sh
START CONF MODE!
CONFIG LIST(default:green, modify:blue, error:red)
--------------------------------------------------------------------------------------
|option              |value                                   |
--------------------------------------------------------------------------------------
|config_file         |config.yml                              |
|input_folders       |["in"]                                  |
|output_folder       |/home/namba/git/filesorting/ruby/out    |
|classification      |["NONE"]                                |
|size                |NONE                                    |
|log                 |false                                   |
|move                |false                                   |
|mode                |CONF                                    |
|date                |NONE                                    |
--------------------------------------------------------------------------------------
```

このプログラムで読み込まれているオプションを一覧で確認できる.  
`value`の色について, 値が初期設定から変わっていないものは**緑**, 変更があるものは**青**, エラーがあるものは**赤**で表示が行われる.  
赤表示が現れるのは, オプションチェックの時にエラーが見つかり, 強制的にこのモードが開かれる時のみとなる.  
オプションの読み込みはオプションの読み込みは**オプション指定 > 設定ファイル > 初期値**の優先度で行われる.  


### 終了モード(QUIT)

何も行わず, 正常に終了を行いたい時に実行する.  



## 使い方 分類モード(初期設定時)

分類モードを選択した時, どの種類で分類を行うかを設定する.  

```sh
START SORT MODE!
input classification (1:EXT, 2:SIZE, 3:DATE (e.g. 1 -> 2)) stop: e 
>>
```

使いたいモードに対応した数字を1つ以上指定が出来る.入力終了は`e`を入力することで行える.  
指定を複数行った時, フォルダ分類を再帰的に行える(例を挙げると, `1 -> 3`とすると, 
拡張子分類をした中で更に最終更新日時分類が行われる).  


### 拡張子モード(EXT)

```sh
START EXT SORT!
output files.
file mode :copy
/home/users/git/filesorting/ruby/in/adjskadfj.txt -> /home/users/git/filesorting/ruby/out/txt
/home/users/git/filesorting/ruby/in/ajaj.tar.gz -> /home/users/git/filesorting/ruby/out/tar.gz
/home/users/git/filesorting/ruby/in/ajkasdhsdf -> /home/users/git/filesorting/ruby/out/NONE
/home/users/git/filesorting/ruby/in/asdklf -> /home/users/git/filesorting/ruby/out/NONE
/home/users/git/filesorting/ruby/in/udhd -> /home/users/git/filesorting/ruby/out/NONE
/home/users/git/filesorting/ruby/in/asdds -> /home/users/git/filesorting/ruby/out/NONE
file sorting done!
```

拡張子名で分類を行う.  拡張子がないものは`NONE`に分類される.  


### ファイルサイズモード(SIZE)

```sh
START SIZE SORT!
input interval size(e.g. 24KB 400MB)
>>20KB
interval size is 20KB
output files.
file mode :copy
/home/users/git/filesorting/ruby/in/adjskadfj.txt -> /home/users/git/filesorting/ruby/out/20KB
/home/users/git/filesorting/ruby/in/ajaj.tar.gz -> /home/users/git/filesorting/ruby/out/20KB
/home/users/git/filesorting/ruby/in/ajkasdhsdf -> /home/users/git/filesorting/ruby/out/20KB
/home/users/git/filesorting/ruby/in/asdklf -> /home/users/git/filesorting/ruby/out/20KB
/home/users/git/filesorting/ruby/in/udhd -> /home/users/git/filesorting/ruby/out/180KB
/home/users/git/filesorting/ruby/in/asdds -> /home/users/git/filesorting/ruby/out/20KB
file sorting done!
```

ファイルサイズを指定された大きさを分割の区切りとして分類を行う.  
`interval size`の入力は`20KB`や`4MB`のように, **数字(1~999)と単位(B~PBまで)**のようにすること.  
指定を行うと, 指定された分割単位でファイルサイズ分類が行われる(例を挙げると, `20KB`とすると, 
`20KB`,`40KB`,`60KB`,...のようにファイルサイズ分類が行われる).  
この時, **ファイルサイズを指定された大きさで分割させる場所の中での繰り上げの場所**に分類が行われる
(例を挙げると, 分割単位を`20KB`とすると, `49KB`のファイルは`40KB`と`60KB`の間になるので, 繰り上げ結果の`60KB`に分類が行われる).  


### 最終更新日時ソート(DATE)

```sh
START DATE SORT!
input date unit(1:YEAR, 2:MONTH, 3:DAY, 4:HOUR, 5:MINUTE)
>>3
date unit is DAY
output files.
file mode :copy
/home/users/git/filesorting/ruby/in/adjskadfj.txt -> /home/users/git/filesorting/ruby/out/2020-01-06
/home/users/git/filesorting/ruby/in/ajaj.tar.gz -> /home/users/git/filesorting/ruby/out/2019-12-30
/home/users/git/filesorting/ruby/in/ajkasdhsdf -> /home/users/git/filesorting/ruby/out/2020-01-04
/home/users/git/filesorting/ruby/in/asdklf -> /home/users/git/filesorting/ruby/out/2020-01-06
/home/users/git/filesorting/ruby/in/udhd -> /home/users/git/filesorting/ruby/out/2020-01-06
/home/users/git/filesorting/ruby/in/asdds -> /home/users/git/filesorting/ruby/out/2020-01-06
```

指定した日時単位までの最終更新日時で分類を行う.  
`date unit`の入力は使いたい日時単位に対応した数字を入力にすること.  
指定を行うと, その指定された単位の時間までで分類が行われる(例を挙げると, `3`とすると, 
`YEAR`,`MONTH`,`DAY`までの内容で最終更新日時分類が行われる).  



## 設定ファイル(config.yml)の編集

```sh
%ruby run.rb --init
load options.
[[init mode]]
making config_file ...
reset all settings! exit process...
%cat config.yml
---
input_folders:
- in
output_folder: out
mode: NONE
date: NONE
size: NONE
classification:
- NONE
log: 'false'
move: 'false'
```

設定ファイルから, `-f`オプション以外の全ての設定が行なえる.  
入力が配列である`input_files`と`classification`は, `- 追加内容`と続くように書けば追加できる.  
入力が真偽値(Rubyの仕様上で言えば存在はしないが...)である`log`と`move`は, 
内容をバッククォートで`true`か`false`で書けば変更できる.  


## LICENSE

This software is released under the MIT License, see LICENSE.md
