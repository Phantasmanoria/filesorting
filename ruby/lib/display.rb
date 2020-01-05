# coding: utf-8

class Display < Col

  def self.conf(opt)
    cputs ["CONFIG LIST(default:green)", 3] # 表題
    cputs ["---------------------------------------------", 3]
    opt = Convert.mode_expand(opt)
    opt.each do |key, value| # 中身の表示
      key = key.to_s
      if comp(key,value) # defaultと同じか違うか判断
        cputs [[key.ljust(20)],["|",3],[value]]
      else
        cputs [[key.ljust(20)],["|",3],[value,1]]
      end
    end
    cputs ["---------------------------------------------", 3]
  end

  def self.comp(key,val1) # default比較
    default={"config_file"=>"config.yml","mode"=>"NONE", "input_folders"=>"[\"in\"]", "output_folder"=>"out", "log"=>nil}
    val2 = eval("default['#{key}']")
    val2 == val1
  end
  
end






