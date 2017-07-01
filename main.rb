require "twitter"
require 'open-uri'
# encoding: utf-8

USERNAME = "fustuu_no_ladio"
$twh = ""

$client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ""
  config.consumer_secret     = ""
  config.access_token        = ""
  config.access_token_secret = ""
end


def tweeet (str)
  if $twh != str
  # p "tweet する"
    $twh = str
$client.update(str)
  else
#p "tweetしない"
  end

end

def get_ladio_list
  open('http://yp.ladio.net/stats/list.v2.dat', 'r:CP932'){|l|
    status = false
    count = 0
    ii = {}
    l.read.split("\n\n").each {|i|
      item = i.encode!("UTF-8")
      if item.include?("普通にねとらじリレー") then
        count = count + 1
        status = true
        item = item.split("\n")
        item.each{|e|
          es = e.split("=",2)
          ii[es[0]] = es[1]
        }
      end
    }
     if status then
    # p count
      if count == 1 then ##ふつらじ放送中
      tweeet(ii["NAM"] + " " + ii["SURL"])
      sleep(10)
      get_ladio_list
      elsif count == 2 then ##（バトン渡し中）
      tweeet("バトンが繋がりそう")
      sleep(10)
      get_ladio_list
      else
      tweeet("3人以上がリレーしている？？")
      sleep(10)
      get_ladio_list
      end

    else
      tweeet("ふつらじリレーが終わりました。")
      sleep(10)
    end
  }
end

loop do
get_ladio_list
sleep(30)
end
