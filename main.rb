#!/usr/bin/ruby
# encoding: utf-8
require "twitter"
require "./init.rb"
require 'open-uri'
require "./function.rb"

# twitterID
USERNAME = $name
# tweetの内容
$tw_str = ""
# twitterの初期設定
$client = Twitter::REST::Client.new do |config|
  config.consumer_key        = $c_k
  config.consumer_secret     = $c_s
  config.access_token        = $a_t
  config.access_token_secret = $a_t_s
end

# 重複ツイートはしないでツイートする
def tweeet (str)
  unless $tw_str == str then
    $tw_str = str
    #$client.update(str)
    p str
  end
end

b_list =  list_filter

loop do
sleep(10)

a_list =  list_filter
henka = a_list.size - b_list.size

if henka == 0 #変化なし
  if $tw_str == ""
    tweeet(a_list[0]["NAM"] + " " +  a_list[0]["SURL"])
  end
  if a_list.size == 0
  tweeet( "まだみぬDJさんバトンはホカホカですよ！" )
  end
elsif henka == 1 or henka == -1 
  if a_list.size == 1 or henka == -1
    tweeet(a_list[0]["NAM"] + " " +  a_list[0]["SURL"] )
  elsif a_list.size == 2 
    tweeet("バトンが繋がりそうな気配がする。。。！" + a_list[1]["SURL"])
  end
else 
  tweeet("3人以上がリレーに参加している！？！？想定外の事態です！" + a_list[2]["SURL"])
end
b_list = a_list
end

