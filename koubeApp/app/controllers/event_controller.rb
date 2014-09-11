# -*- coding: utf-8 -*-
require "open-uri"
class EventController < ApplicationController
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
  # /event/show/11 
  def show
  end
end
