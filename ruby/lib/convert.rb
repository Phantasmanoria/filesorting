# coding: utf-8
require "colorize"

class Col # カラー描写
  def cputs(words)
    words = [[words, "green"]] if words.kind_of?(String) # 文字のみはgreen処理
    for word,color in words
      color = Convert.num_color(color) if color.kind_of?(Integer) # 色数字変換
      color = "green" if color.nil?
      eval("print word.colorize(:#{color})")
    end
    puts 
  end
  def cerr(word)
    eval("STDERR.print word.colorize(:red)"); puts
  end
  def self.cputs(words)
    words = [[words, "green"]] if words.kind_of?(String) # 文字のみはgreen処理
    for word,color in words
      color = Convert.num_color(color) if color.kind_of?(Integer) # 色数字変換
      color = "green" if color.nil? 
      eval("print word.colorize(:#{color})")
    end
    puts
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

end
