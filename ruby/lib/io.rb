# coding: utf-8
class InOut < Col
  attr_accessor :list # ファイルリスト共有のため操作を受け付ける
  
  def initialize(params) 
    @list = Array.new
    pwd = Dir.pwd # 初期ディレクトリ
    input(pwd, params[:o], params[:i])
    Dir.chdir(pwd) # 初期ディレクトリ
    puts @list
  end

  def input(pwd, out, folders) # 回帰的なファイル捜索
    for folder in folders
      cputs pwd 
      Dir.chdir(pwd) # 現在立っている場所
      Dir.chdir(folder) # 指名された場所に移動する
      tpwd = Dir.pwd
      for file in Dir.glob("*") # 移動先でファイル捜索
        break if file.nil?
        path = tpwd + "/"+ file # 捜査ファイルのパス確保
        if File.directory?(path) # ディレクトリならその中を再帰捜索
          cputs [path, 1]
          input(tpwd, out, [path])
        elsif File.file?(path) # ファイルならリスト挿入
          puts out
          @list.push([path,out,File.stat(path)]) # [初期パス, 移動先パス, 情報]
        end
      end
    end
  end

  def output


  end
  
end
