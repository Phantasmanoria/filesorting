# coding: utf-8
class Sort < Col # 移動先の変更を行う

  def self.main(list, opt)
    puts list

    if opt[:s].include?("NONE")
      cprint ['input sort! (EXT, SIZE, DATE (e.g. EXT,DATE))',3]
      opt[:s] = Convert.num_mode(Col.cgets)
    end
    
    for sort in opt[:s] # 各ソートを実行
      list = ext(list, opt)  if sort == "EXT"
      list = size(list, opt) if sort == "SIZE"
      list = date(list, opt) if sort == "DATE"
    end

    puts
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


  def self.size(list, opt)


  end


  def self.date(list, opt)


  end


end
