# coding: utf-8
class InOut < Col
  attr_accessor :f_list # ファイルリスト共有のため操作を受け付ける
  
  def initialize(params) 
    @list = Array.new
    pwd = Dir.pwd # 初期ディレクトリ
    input(params[:i], pwd)
    puts @list
  end

  def input(folders, pwd) # 回帰的なファイル捜索
    for folder in folders
      cputs pwd
      Dir.chdir(pwd)
      Dir.chdir(folder)
      tpwd = Dir.pwd
      for file in Dir.glob("*")
        break if file.nil?
        path = tpwd + "/"+ file
        if File.directory?(path) # ディレクトリならその中を再帰捜索
          cputs [path, 1]
          input([path], path)
        elsif File.file?(path) # ファイルならリスト挿入
          cputs [path, 3]
          @list.push([path, File.stat(path)])
        end
      end
    end
  end

  def output


  end
  
end
