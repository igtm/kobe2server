# -*- coding: utf-8 -*-
require "open-uri"
class EventController < ApplicationController
  
  # HTML解析に使うメソッド（getDoc, render_json）
  def getDoc(url)
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得                                                                   
      f.read # htmlを読み込んで変数htmlに渡す                                                                
    end
    print "charset="+charset
    if charset == "iso-8859-1" then charset="utf-8" end
    # htmlをパース(解析)してオブジェクトを生成                                                               
    doc = Nokogiri::HTML.parse(html, nil, charset)
    return doc
  end
  def render_json(json_data)
    response.headers['Content-Type'] = 'application/javascript; charset=utf-8'
    callback_method = params[:callback]
    respond_to do |format|
      format.html
      format.json {  render :json => json_data,callback: callback_method}
    end    
  end
  
  # /event/list
  # イベント一覧情報をJSONで受け渡す
  def list
    # スクレイピング先のURL                                                     
    url = 'http://umie.jp/news/event/'
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得                                      
      f.read # htmlを読み込んで変数htmlに渡す                                   
    end
    # htmlをパース(解析)してオブジェクトを生成                                  
    doc = Nokogiri::HTML.parse(html, nil, charset)
    events = []
    doc.xpath('//div[@class="eventNewsBox"]').each do |node|
      # タイトルを表示                                                          
      hash = {}
      hash["title"] = node.css('h3').inner_text
      hash["image"] = "http://umie.jp/" + node.css('img').attribute('src').value 
      events.push(hash)
    end
    response.headers['Content-Type'] = 'application/javascript; charset=utf-8'
    json_data = events.to_json
    callback_method = params[:callback]
    respond_to do |format|
      format.html
      format.json {  render :json => json_data,callback: callback_method}
    end
  end

  # /event/umie.json
  def umie
    doc = getDoc('http://umie.jp/news/event/')
    events = []
    doc.xpath('//div[@class="eventNewsBox"]').each do |node|
      # タイトルを表示                                                                                       
      hash = {}
      hash["title"] = node.css('h3').inner_text
      hash["image"] = "http://umie.jp/" + node.css('img').attribute('src').value
      events.push(hash)
    end
    render_json(events.to_json)
  end
  def premium_outlet
    doc = getDoc("http://www.premiumoutlets.co.jp/kobesanda/events/")
    events = []
    doc.xpath('//div[@class="block"]').each do |node|
      hash = {}
      hash["title"] = node.css('h4').inner_text
      hash["image"] = null
      # hash["content"] = node.css('.det-txt').inner_text
      events.push(hash)
    end
    render_json(events.to_json)
  end
  def mitsui_outlet
    open_url = "http://www.31op.com/kobe/news/open.html"
    shop_url = "http://www.31op.com/kobe/news/shop.html"
    event_url = "http://www.31op.com/kobe/news/event.html"
    urls = [open_url,shop_url,event_url]
    allInfo = []
    urls.each do |url|
      doc = getDoc(url)
      doc.xpath('//div[@class="list_box"]').each do |node|
        hash = {}
        hash["title"] = node.css('h3').inner_text + " " + node.css(".shop_name").inner_text
        hash["image"] = "http://www.31op.com/kobe/news/" + node.css('img').attribute('src').value
        allInfo.push(hash)
      end
    end
    render_json(allInfo.to_json)
  end
  # /event/show/11 
  def show
  end
end
