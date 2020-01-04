# coding: utf-8
require 'optparse' # optパーサー読み取り
require 'fileutils' # ファイル操作


#外部クラス読み込み
path = File.expand_path('./lib')
require path + '/opt'
require path + '/input'
require path + "/analysis"
require path + "/save"
require path + "/display"
require path + "/log"


