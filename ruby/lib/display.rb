# coding: utf-8

class Display < Col

  def self.conf(opt)
    cputs ["CONFIG LIST(default:green)", 3] # 表題
    cputs ["-"*`tput cols`.chomp.to_i, 3]
    cputs [["option".ljust(20),3],["|",3],["value",3]]
    cputs ["-"*`tput cols`.chomp.to_i, 3]
    opt = Convert.mode_expand(opt)
    opt.each do |key, value| # 中身の表示
      key = key.to_s
      if comp(key,value) # defaultと同じか違うか判断
        cputs [[key.ljust(20)],["|",3],[value]]
      else
        cputs [[key.ljust(20)],["|",3],[value,1]]
      end
    end
    cputs ["-"*`tput cols`.chomp.to_i, 3]
  end

  
  def self.comp(key,val1) # default比較
    default={"config_file"=>"config.yml","mode"=>"NONE", "input_folders"=>"[\"in\"]", "output_folder"=>File.expand_path("out"), "log"=>nil}
    val2 = eval("default['#{key}']")
    val2 == val1
  end


  def self.file_list(lists)
    cputs ["FILE LIST", 3] # 表題
    
    cputs ["-"*`tput cols`.chomp.to_i, 3]
    cputs [["path".ljust(40)],["|",3],["size".ljust(6)],["|",3],["ext".ljust(10)],["|",3]]
    cputs ["-"*`tput cols`.chomp.to_i, 3]
    lists.each do |file, info|
      cputs [[Convert.str_reduct(file,40)],["|",3],[Convert.num_byte(info.size.to_s).rjust(6)],
             ["|",3],[Convert.str_ext(file).rjust(10)],["|",3]]
    end
    cputs ["-"*`tput cols`.chomp.to_i, 3]
  end

  
end






