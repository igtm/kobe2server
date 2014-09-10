#!/usr/bin/ruby                                                                                                        
# -*- coding: utf-8 -*-                                                                                                 
print "Content-type:text/json\n\n"

# URLにアクセスするためのライブラリの読み込み                                                                           
# # Nokogiriライブラリの読み込み     
# require 'nokogiri'
require 'json'
require 'open-uri'
test_url = "http://4804c19e.ngrok.com/umie.rb"
json = open(test_url).read
print json
