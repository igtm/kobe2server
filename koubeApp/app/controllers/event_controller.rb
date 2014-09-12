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


  # /event/list.json
  # イベント一覧情報をJSONで受け渡す                                                                    
  def list
    allEvents = []
    umie_scraping(allEvents)
    sanda_scraping(allEvents)
    mitsui_scraping(allEvents)
    # sort
    allEvents = allEvents.sort_by{|hash| hash['title']}
    render_json(allEvents.to_json)
  end

  # /event/umie.json
  def umie
    events = []
    umie_scraping(events)
    render_json(events.to_json)
  end
  def umie_scraping(events)
    doc = getDoc('http://umie.jp/news/event/')
    doc.xpath('//div[@class="eventNewsBox"]').each do |node|
      # タイトルを表示                                                                                       
      hash = {}
      hash["outlet"] = "umie"      
      hash["title"] = node.css('h3').inner_text
      hash["image"] = "http://umie.jp/" + node.css('img').attribute('src').value
      events.push(hash)
    end
  end
  
  # /event/umie.json
  def sanda
    events = []
    sanda_scraping(events)
    render_json(events.to_json)
  end
  def sanda_scraping(events)
    url = "http://www.premiumoutlets.co.jp"
    doc = getDoc( url + "/kobesanda/events/" )
    # refUrl: http://white.s151.xrea.com/blog/2008-02-11-10-36.html                                     
    doc.xpath('//div[contains(concat(" ",normalize-space(@class)," "), " block ")]').each do |node|
      hash = {}
      hash["outlet"] = "sanda"
      hash["title"] = node.css('h4').inner_text
      img = node.css('.img_right').css('img')
      if img.blank? then
        hash["image"] = nil
      else
        hash["image"] = url + img.attribute('src').value
      end
      # hash["content"] = node.css('.det-txt').inner_text
      events.push(hash)
    end
  end

  # /event/mitsui.json
  def mitsui
    events = []
    mitsui_scraping(events)
    render_json(events.to_json)
  end
  def mitsui_scraping(events)
    open_url = "http://www.31op.com/kobe/news/open.html"
    shop_url = "http://www.31op.com/kobe/news/shop.html"
    event_url = "http://www.31op.com/kobe/news/event.html"
    urls = [open_url,shop_url,event_url]
    urls.each do |url|
      doc = getDoc(url)
      doc.xpath('//div[@class="list_box"]').each do |node|
        hash = {}
        hash["outlet"] = "mitsui"
        hash["title"] = node.css('h3').inner_text + " " + node.css(".shop_name").inner_text
        hash["image"] = "http://www.31op.com/kobe/news/" + node.css('img').attribute('src').value
        events.push(hash)
      end
    end
  end
  
  # /event/show/11                                               
  def show
  end
end
