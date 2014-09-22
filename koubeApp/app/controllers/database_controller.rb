
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

		allVarieties = varietyList()
		allVarieties.each do |hash|
			variety = Variety.new(hash)
			variety.save unless Variety.exists?(title:hash["title"]) #一度保存したら新規保存しない
		end
		content = Content.all
		render_json(content)
	end

	# 雑貨屋一覧情報をJSONで受け渡す
	def varietyList
		varieties = []
		zakka30min(varieties)

		return varieties
	end
	
	def zakka30min(array)
		urls = ['http://zakka.30min.jp/hyogo/1','http://zakka.30min.jp/hyogo/2']
		urls.each do |url|
			doc = getDoc(url)
			doc.xpath('//div[@class="photo_grid_data"]').each do |node|
				hash = Hash.new
			   	hash["title"] = node.css('h2').inner_text #店名
			   	hash["imageFlag"] = false # 画像の有無
			   	hash["imageFlag"] = true unless node.css('img').blank? 
		   		hash["image"] = node.css('img').attribute('src').value if hash["imageFlag"] #画像のURL
		   		hash["content"] = node.xpath('//p[@class="guide_place_comment20"]').text #説明文
		   		hash["address"] = node.xpath('//div[@class="photo_data"]').css("p").text.split("：")[1].split("/")[0] #住所
		   		hash["site_url"] = "http://zakka.30min.jp" + node.css('a').attribute('href').value #URL
		   		hash["category"] = "Variety"
		   		geocodeing_api(hash,hash["address"]) unless hash["address"].blank?
		   		array.push(hash)
		   	end
		end
	end

	#yahooさんのGEO_APIを利用
	def geocodeing_api(hash,address)
		base_url = "http://geo.search.olp.yahooapis.jp/OpenLocalPlatform/V1/geoCoder?appid="
		appid = "dj0zaiZpPVk0S2lzOW1kZG1ZTiZzPWNvbnN1bWVyc2VjcmV0Jng9YTQ-"
		param = "&query="+URI.encode(address)+"&output=xml&ac=28100&al=4&recursive=true"
		url = base_url + appid + param
		doc = getDoc(url)
		doc.xpath("//coordinates").each do |node|
			lon_lat = node.inner_text.split(",")
			hash["longitude"] = lon_lat[0]
			hash["latitude"] = lon_lat[1]
		end
	end
	
	# /event/list.json
  	# イベント一覧情報をJSONで受け渡す
	def list
		allEvents = []
		umie_scraping(allEvents)
		sanda_scraping(allEvents)
		mitsui_scraping(allEvents)
		feelkobe_scraping(allEvents)
	    # sort
	    allEvents = allEvents.sort_by{|hash| hash['title']}
	    return allEvents
	end

	def feelkobe_scraping(events)
		doc = getDoc("http://www.feel-kobe.jp/event/")
		doc.xpath('//div[@class="inner_box"]').each do |node|
			hash = {}
			hash["category"] = "Feelkobe"
			hash["title"] = node.css("h6").inner_text
			img = node.at("img")
			unless img.blank?
				img_url = img.attribute("src").value
				hash["image"] = "http://www.feel-kobe.jp" + img_url
				hash["imageFlag"] = true
			else
				hash["image"] = ""
				hash["imageFlag"] = false
			end
			content = node.css("p")[3]
			hash["content"] = content.inner_text unless content.blank?
			hash["site_url"] = "http://www.feel-kobe.jp"
			hash["site_url"] = "http://www.feel-kobe.jp" + content.css("a").attribute("href").value unless content.blank?
			events.push(hash) unless hash["title"].blank?
		end
	end
	#イベント説明取得失敗
	def umie_scraping(events)
	    doc = getDoc('http://umie.jp/news/event/')
	    doc.xpath('//div[@class="eventNewsBox"]').each do |node|
	    	# タイトルを表示                                                                              
	    	hash = {}
	    	hash["category"] = "Umie"
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
	     	hash["content"] = node.css(".commentBox").inner_text
	     	link = node.css(".clearfix").css("a")
	     	hash["site_url"] = "http://umie.jp" + link.attribute("href").value unless link.blank?
	     	events.push(hash)
	    end
	end

	def sanda_scraping(events)
		# http://www.premiumoutlets.co.jp/kobesanda/events/
	    url = "http://www.premiumoutlets.co.jp"
	    doc = getDoc( url + "/kobesanda/events/" )
	    # refUrl: http://white.s151.xrea.com/blog/2008-02-11-10-36.html
	    doc.xpath('//div[contains(concat(" ",normalize-space(@class)," "), " block ")]').each do |node|
	    	hash = {}
	    	hash["category"] = "Sanda"
	    	hash["title"] = node.css('h4').inner_text
	    	img = node.css('.img_right').css('img')

	    	if img.blank? then
	        	hash["image"] = ""
	        	hash["imageFlag"] = false
	      	else
	        	hash["image"] = url + img.attribute('src').value
	        	hash["imageFlag"] = true
	      	end
	      	hash["content"] = node.css('.det-txt').css('p')[1].inner_text
	      	hash["site_url"] = "http://www.premiumoutlets.co.jp/kobesanda/events/"
	      	events.push(hash)
	    end
	end
	#イベント説明取得失敗
	def mitsui_scraping(events)
	    open_url = "http://www.31op.com/kobe/news/open.html"
	    shop_url = "http://www.31op.com/kobe/news/shop.html"
	    event_url = "http://www.31op.com/kobe/news/event.html"
	    urls = [open_url,shop_url,event_url]
	    urls.each do |url|
	    	doc = getDoc(url)
	    	doc.xpath('//div[@class="list_box"]').each do |node|
	        	hash = {}
	        	hash["category"] = "Mitsui"
		        hash["title"] = node.css('h3').inner_text + " " + node.css(".shop_name").inner_text
		        img = node.css('img')
		        unless img.blank?
		        	hash["image"] = "http://www.31op.com/kobe/news/" + img.attribute('src').value
		          	hash["imageFlag"] = true
		        else
		          	hash["image"] = ""
		          	hash["imageFlag"] = false
		        end
		        detail = node.css(".detail_box").css("div")
		        hash["content"] = detail.inner_text unless url == event_url && detail.blank?
		        hash["content"] = detail[1].inner_text if url == event_url && !detail.blank?
		        link = node.css(".shop_name").css("a")
		        hash["site_url"] = "http://www.31op.com/kobe/news/event.html" if link.blank?
		        hash["site_url"] = "http://www.31op.com/kobe/news/" + link.attribute("href").value unless link.blank?
		        
		        events.push(hash)
	      	end
	    end
	end


end