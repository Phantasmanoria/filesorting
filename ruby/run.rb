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


opt = Opt.new

puts("")
