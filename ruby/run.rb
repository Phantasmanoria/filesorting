# coding: utf-8
require 'optparse' # optパーサー読み取り
require 'fileutils' # ファイル操作
require 'ruby-progressbar' # 経過時間表示 

#外部クラス読み込み
path = File.expand_path('./lib')
require path + "/opt"
require path + "/input"
require path + "/output"
require path + "/sort"
require path + "/display"
require path + "/convert"
require path + "/log"


option = Opt.new
opt = option.param

if opt[:m] == "NONE" # モード指定がない時, ここで選択する
  puts("select mode! (1:SORT, 2:LIST, 3:CONF, 4:QUIT)")
  opt[:m] = Convert.num_mode(gets.chomp)
end

puts "START #{opt[:m]} MODE!" # モード選択

if opt[:m] == "SORT" 
  puts "sort"
elsif opt[:m] == "LIST"
  puts "list"
elsif opt[:m] == "CONF"
  puts "conf"
elsif opt[:m] == "QUIT"
  puts "quit this program."
  exit 0
else # 例外処理(直接入力時に発揮)
  STDERR.print("mode #{opt[:m]} is wrong mode!\n")
  exit 1
end
