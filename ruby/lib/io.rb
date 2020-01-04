# coding: utf-8
class InOut < Col
  attr_accessor :f_list # ファイルリスト共有のため操作を受け付ける
  
  def initialize(params) 
    @list = []
    pwd = Dir.pwd
    input(params[:i], pwd)
    puts @list
  end

  def input(folders, pwd)
    for folder in folders
      cputs pwd
      Dir.chdir(pwd)
      Dir.chdir(folder)
      tpwd = Dir.pwd
      for file in Dir.glob("*")
        path = tpwd + "/"+ file
        if File.directory?(path)
          cputs [path, 1]
          input([path], path)
        elsif File.file?(path)
          cputs [path, 3]
          @f_list.push([path, File.stat(path)])
        end
      end
    end
  end

  def output


  end
  
end
