# coding: utf-8
require 'optparse'
require 'yaml'

# 初期情報を取得
class Opt < Col
  
  def initialize
    cputs "load options."
    param = get_opt
    cputs "load config_file."
    yaml = yaml_load(param[:f])
    cputs "check options.."
    mix_check(param,yaml)
  end

  def param # paramの取得(外部取得を防ぐため)
    @params
  end
  
  private
  def get_opt # オプションから情報を入手
    opt = OptionParser.new
    params = {f:"config.yml", # 初期値の設定
              m:"NONE",
              i:["in"],
              o:"out",
             }         
    begin
      opt.on('-f [FILE]', Array,
             'config file (default:config.yml)')  {|v| params[:f] = v}
      opt.on('-i [FOLDER, FOLDER, ..]', Array,
             'input folders (default:[./in])')  {|v| params[:i] = v}
      opt.on('-o [FOLDER]',
             'output folder (default:./out)')  {|v| params[:o] = v}
      opt.on('-m [MODE]', ['SORT', 'LIST', 'CONF', 'NONE'],
             'mode (SORT | LIST | CONF | NONE) (default:NONE)')  {|v| params[:m] = v}
      opt.on('-l', 'log mode (default:off)')  {|v| params[:l] = v}
      opt.on('--init', 'reset all settings (default:off)')  {|v| params[:init] = v}
      opt.parse!(ARGV)
    rescue => e # エラー処理
      cerr "ERROR: #{e}.\nSee option!\n#{opt}"
      exit
    end

    unless params[:init].nil? # init実行時は初期設定実行後に終了
      cputs "[[init mode]]"
      unless File.exist?("in") # inファイル
        cputs "make input folder."
        Dir.mkdir("in")
      end
      unless File.exist?("out") # outファイル
        cputs "make output folder."
        Dir.mkdir("out")
      end
      FileUtils.rm("config.yml") if File.exist?("config.yml")
      mkconfig # configファイル作り直し
      cputs "reset all settings! exit process..."
      exit 0 # 終了
    end
    params
  end

  def yaml_load(conf) # yaml読み込み
    until File.exist?(conf) 
      cerr "ERROR: config_file #{conf} is not exist!\n"
      if conf != "config.yml"  # -fのコンフィグファイルが存在しないと標準ファイルに変更
        cputs "change from #{conf} to config.yml"
        conf = "config.yml"
      else # 標準ファイルがなければ作成
        mkconfig
      end      
    end

    yaml = YAML.load_file(conf) until yaml # 読み込み
    res = {}
    # 情報読み取り
    res[:i] = yaml[:input_folders] if yaml[:input_folders] 
    res[:o] = yaml[:output_folder] if yaml[:output_folder]
    res[:m] = yaml[:mode] if yaml[:mode]
    res[:l] = yaml[:log] if yaml[:log] == "true"

    res[:f] = conf # conf情報上書き
    
    res
  end


  def mkconfig # configファイル作成
    cputs "making config_file ..."
    data = {
      "input_folders" => ["input"],
      "output_folder" => "output",
      "mode" => nil,
      "log" => nil
    }
    YAML.dump(data, File.open("config.yml", "w"))
  end

  
  def mix_check(param, yaml) # オプションの統合と有効判定

    conf = yaml[:f] # fオプションのみ救済
    res = yaml.merge(param) # yaml設定よりもopt設定の方を優先で上書き
    res[:f] = conf # fオプションの適応

    for f_name in res[:i] # -iでのフォルダが存在しないとエラー終了
      unless Dir.exist?(f_name)
        cerr "ERROR: input_folder #{f_name} is not exist!"
        exit 1
      end
    end

    unless Dir.exist?(res[:o]) # -oでのフォルダが存在しないとエラー終了
      cerr "ERROR: output_folder #{f_name} is not exist!"
      exit 1
    else
      res[:o] = File.expand_path(res[:o])
    end

    if res[:m].nil? # -mでのモードが該当しないとエラー終了(optperseによりnilになる)
      cerr "ERROR: invalid argument -m!(syntax error)"
      exit 1
    end
    @params = res
  end

end

