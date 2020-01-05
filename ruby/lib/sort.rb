# coding: utf-8
class Sort < Col # 移動先の変更を行う

  def self.main(list, opt)
    puts list

    if opt[:c].include?("NONE") # NONE時はここで入力
      tmp = []; c = "" # 一時変数
      cprint ['input classification (EXT, SIZE, DATE (e.g. EXT,DATE)) stop: e ',3]
      tmp.push(c) while (c = Col.cgets) != "e"

      j = ["EXT", "SIZE", "DATE"] # 検証
      tmp.each do |sort|
        if not j.include?(sort) # 候補外はエラー
          cerr "ERROR: sort #{sort} is wrong sort!"
          exit 1
        end
      end
      opt[:c] = tmp
    end
    
    for sort in opt[:c] # 各ソートを実行
      cputs "START #{sort} SORT!"
      list = ext(list, opt)  if sort == "EXT"
      list = size(list, opt) if sort == "SIZE"
      list = date(list, opt) if sort == "DATE"
    end

    puts list

    list
  end

  
  def self.ext(list, opt) # 拡張子
    res = []
    list.each do |file, path, info|
      res.push([file, path+"/"+Convert.str_extfolder(file), info])
    end
    res
  end


  def self.size(list, opt) # サイズ
    res = []
    list.each do |file, path, info|
      








      
      res.push([file, path+"/"+Convert.str_extfolder(file), info])
    end
    res
  end


  def self.date(list, opt)


  end


end
