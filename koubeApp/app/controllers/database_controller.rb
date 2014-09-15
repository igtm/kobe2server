
class DatabaseController < ApplicationController
	
	# /database/update
	# DBの更新
	def update
		allEvents = list()
		# json => database
		allEvents.each do |hash|
			content = Content.new(hash)
			content.save unless Content.exists?(title:hash["title"]) #一度保存したら新規保存しない
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
	    return allEvents
	end
	
	def umie_scraping(events)
	    doc = getDoc('http://umie.jp/news/event/')
	    doc.xpath('//div[@class="eventNewsBox"]').each do |node|
	    	# タイトルを表示                                                                                    
	    	hash = {}
	    	hash["category"] = "umie"
	    	hash["title"] = node.css('h3').inner_text
	    	img = node.css('img')
	    	unless img.blank?
	        	img_url = img.attribute('src').value
		        hash["image"] = "http://umie.jp/" + img_url
		        hash["imageFlag"] = true
	    	else
	        	hash["image"] = ""
		        hash["imageFlag"] = false
	     	end
	      	events.push(hash)
	    end
	end
	
	def sanda_scraping(events)
	    url = "http://www.premiumoutlets.co.jp"
	    doc = getDoc( url + "/kobesanda/events/" )
	    # refUrl: http://white.s151.xrea.com/blog/2008-02-11-10-36.html
	    doc.xpath('//div[contains(concat(" ",normalize-space(@class)," "), " block ")]').each do |node|
	    	hash = {}
	    	hash["category"] = "sanda"
	    	hash["title"] = node.css('h4').inner_text
	    	img = node.css('.img_right').css('img')

	    	if img.blank? then
	        	hash["image"] = ""
	        	hash["imageFlag"] = false
	      	else
	        	hash["image"] = url + img.attribute('src').value
	        	hash["imageFlag"] = true
	      	end
	      	# hash["content"] = node.css('.det-txt').inner_text
	      	events.push(hash)
	    end
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
	        	hash["category"] = "mitsui"
		        hash["title"] = node.css('h3').inner_text + " " + node.css(".shop_name").inner_text
		        img = node.css('img')
		        unless img.blank?
		        	hash["image"] = "http://www.31op.com/kobe/news/" + img.attribute('src').value
		          	hash["imageFlag"] = true
		        else
		          	hash["image"] = ""
		          	hash["imageFlag"] = false
		        end
		        events.push(hash)
	      	end
	    end
	end
end