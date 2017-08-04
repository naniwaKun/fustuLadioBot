#!/usr/bin/ruby
# encoding: utf-8
require 'open-uri'
require 'json'

def get_ladio_list 
  ret = []
  open('http://yp.ladio.net/stats/list.v2.dat', 'r:CP932'){|l|
    l.read.split("\n\n").each {|i|
      item = {}
      str = i.encode!("UTF-8")
      list = str.split("\n")
      list.each{|e|
        es = e.split("=",2)
        item[es[0]] = es[1]
      }
      ret.push(item)
    }
  }
  ret.sort! do |a, b|
    a["TIMS"] <=> b["TIMS"]
  end
  return ret
end

def save_status(i)
  if i.length == 1  then
    l = i[0]
    url = "http://" + l["SRV"].to_s + ":" + l["PRT"].to_s + l["MNT"].to_s 
    str = '<audio src = ' + url + ' autoplay controls>'
    File.open("./web/live/audio_html", "w") do |f|
      f.puts(str)
    end
  end 
end

def list_filter
  ret =[]
  arr = get_ladio_list
  arr.each {|i|
    ret.push(i) if  i["NAM"].include?("普通に")
  }
  return ret
end

list = list_filter
save_status(list)

