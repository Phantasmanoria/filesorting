# coding: utf-8

# Copyright (c) 2020 Phantasmanoria
# This software is released under the MIT License, see LICENSE.md

require 'optparse' # optパーサー読み取り
require 'fileutils' # ファイル操作

#外部クラス読み込み
path = File.expand_path('./lib')
require path + "/convert"
require path + "/opt"
require path + "/io"
require path + "/classification"
require path + "/display"
require path + "/log"

# main

option = Opt.new # オプション取得
opt = option.param
files = InOut.new(opt) # 入力リスト読み取り

if opt[:l] # ログ機能の使用
  time = Time.now.strftime("%Y%m%d-%H%M%S") # 時間取得
  Log.output("log/"+time+".log")  
end

  
if opt[:m] == "NONE" # モード指定がない時, ここで選択する
  Col.cputs ["select mode! (1:SORT, 2:LIST, 3:CONF, 4:QUIT)", 3]
  opt[:m] = Convert.num_mode(Col.cgets)
end
  
Col.cputs "START #{opt[:m]} MODE!" # モード選択宣言

if opt[:m] == "SORT" 
  files.list = Classification.main(files.list,opt)
  files.output(opt)
elsif opt[:m] == "LIST"
  Display.file_list(files.list)
elsif opt[:m] == "CONF"
  Display.conf(opt)
elsif opt[:m] == "QUIT"
  Col.cputs "quit this program."
  exit 0
else # 例外処理(直接入力時に発揮)
  Col.cerr "ERROR: input wrong mode!"
  exit 1
end
