# coding: utf-8
require "colorize"

class Col # カラー描写(カーネル上書きは継承のためしていない)
  def cprint(words)
    words = [words, "green"] if words.kind_of?(String) # 文字のみはgreen処理
    words = [words] if words[0].kind_of?(String) # 一次元配列は二次元変換
    for word,color in words
      color = Convert.num_color(color) if color.kind_of?(Integer) # 色数字変換
      color = "green" if color.nil?
      eval("print word.colorize(:#{color})")
    end
  end
  def cputs(words)
    cprint(words)
    puts 
  end
  def cgets
    cprint([">>",5])
    res = gets
    res.chomp
  end
  def cerr(word)
    eval("STDERR.print word.colorize(:red)"); puts
  end
  
  def self.cprint(words)
    words = [words, "green"] if words.kind_of?(String) # 文字のみはgreen処理
    words = [words] if words[0].kind_of?(String) # 一次元配列は二次元変換
    for word,color in words
      color = Convert.num_color(color) if color.kind_of?(Integer) # 色数字変換
      color = "green" if color.nil? 
      eval("print word.colorize(:#{color})")
    end
  end
  def self.cputs(words)
    cprint(words)
    puts
  end
  def self.cgets
    cprint([">>",5])
    res = gets
    res.chomp
  end
  def self.cerr(word)
    eval("STDERR.print word.colorize(:red)"); puts
  end
end



class Convert # 小規模の変換等の機能の格納

  def self.num_mode(num) # 数字 -> モード
    if num.to_i >=1 && num.to_i <=4
      list = ["SORT", "LIST", "CONF", "QUIT"]
      eval("list[#{num.to_i-1}]")
    else nil
    end
  end
  
  def self.num_color(num) # 数字 -> 色
    if num.to_i >=0 && num.to_i <=6
      #        0     1      2       3        4         5       6       7      8
      list = ["red","blue","green","yellow","magenta","white","black","cyan","default"]
      eval("list[#{num.to_i}]")
    else nil
    end
  end

  def self.opt_expand(opt) # モード名の拡張
    res = {}
    opt.each do |key, value|
      tmp = opt_name(key.to_s)
      eval("res[:#{tmp}] = '#{value}'")
    end
    res
  end

  def self.opt_name(str) # モード名返信
    list = {"f" => "config_file",
            "m" => "mode",
            "i" => "input_folders",
            "o" => "output_folder",
            "s" => "sort",
            "l" => "log"
           }
    eval("list['#{str}']")
  end

  def self.str_reduct(str,len,side="l") # 文字列の略化
    res = str; len -= 1
    res = "~"+res[str.length-len,len] if str.length > len+1 # オーバー時に縮小
    res = res.ljust(len+1) if side == "l" # 左調整
    res = res.rjust(len+1) if side == "r" # 右調整
    res
  end

  def self.num_byte(num) # バイト数の文字列変換
    units = ["  B"," KB"," MB"," GB"," TB"," PB"] # 
    u = 0
    num = num.to_i
    
    while num / 1000.0 > 1.0
      u += 1
      num /= 1000
    end
    num.to_s + units[u]
  end

  def self.str_ext(str1) # 拡張子抽出
    str1 = str1.gsub(/[^\/]*\//, "")
    str2 = str1.sub(/[^\.]*\./, "")
    str2= "NONE" if str1 == str2
    str2
  end

  def self.str_extfolder(str) # 拡張子抽出
    str = str_ext(str)
    str.gsub!(/\./, "\\\.")
    str
  end

  
end
