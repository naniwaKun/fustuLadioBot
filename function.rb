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

def save_status
  list = get_ladio_list
#  list = list_filter
  str = JSON.generate( list )
  return str
end

def list_filter
  ret =[]
  arr = get_ladio_list
  arr.each {|i|
    ret.push(i) if  i["NAM"].include?("普通に")
  }
  return ret
end

