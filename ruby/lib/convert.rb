# coding: utf-8
class Convert # 小規模の変換等の機能の格納

  def self.num_mode(num)
    if num.to_i >=1 && num.to_i <=4
    list = ["SORT", "LIST", "CONF", "QUIT"]
    eval("list[#{num.to_i-1}]")
    else nil
    end
  end
  

end
