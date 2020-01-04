# coding: utf-8
require 'optparse'

# 初期情報を取得
class Opt

  def initialize
    @params = check(get_opt)
  end

  
  def param # オプションの表示
    @params
  end

  private
  def get_opt # オプションから情報を入手
    opt = OptionParser.new
    params = {f:"config.yml", # 初期値の設定
              m:[""],
              i:[""],
              o:"",
             }         
    begin
      opt.on('-f [FILE]', Array,
             'config file (default:config.yml)')  {|v| params[:f] = v}
      opt.on('-i [FOLDER, FOLDER, ..]', Array,
             'input folders (default:./in)')  {|v| params[:i] = v}
      opt.on('-o [FILE]',
             'output folder (default:./out)')  {|v| params[:o] = v}
      opt.on('-m [MODE]', ['DISP', 'DATE', 'SIZE', 'EXT'], Array,
             'mode (DISP | DATE | SIZE | EXT) (default:NONE)')  {|v| params[:m] = v}
      opt.on('-l', 'log  output mode (default:off)')  {|v| params[:l] = v}
      opt.parse!(ARGV)
    rescue => e # エラー処理
      puts "ERROR: #{e}.\n See #{opt}!"
      exit
    end
    params
  end

=begin  
  def check(params) # オプションの有効判定
    for f_name in params[:f] # -fでのファイル名が存在しないとエラー終了
      unless File.exist?(f_name)
        STDERR.print "ERROR: input_file #{f_name} is not exist!\n"
        exit 1
      end
    end

    if params[:m].nil? # -mでのモードが該当しないとエラー終了(optperseによりnilになる)
      STDERR.print "ERROR: invalid argument -m!(syntax error)\n"
      exit 1
    end
    params[:m] = ["HOUR", "HOST"] if params[:m][0] == "BOTH" #BOTHの時は両方入れる

    params
  end
=end
end

