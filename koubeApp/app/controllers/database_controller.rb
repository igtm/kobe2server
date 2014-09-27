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
		content = Content.all # 試し表示
		render_json(content)
	end

	# /event/list.json
  	# イベント一覧情報をJSONで受け渡す
	def list
		all = []
		umie_scraping(all)
		sanda_scraping(all)
		mitsui_scraping(all)
		feelkobe_scraping(all)

		zakka30min(all)
		rankingshare(all)
	    # sort
	    all = all.sort_by{|hash| hash['title']}
	    return all
	end

	def rankingshare(array)
		url = "http://www.rankingshare.jp/tag/492497/"
		doc = getDoc(url)
		doc.css(".tag-list").css("li").each do |li|
			_url = li.css("a").attribute("href").value
			_doc = getDoc(_url)
			[1,2,3,4,5].each do |i|
				node = _doc.css(".num-"+ i.to_s)
				next if node.blank?
				hash = Hash.new
				hash["image"] = node.css(".rank-img").css("img").attribute("src").value
				hash["imageFlag"] = hash["image"].blank? ? false : true
				hash["title"] = node.css("dt").css("a").inner_text
				hash["content"] = node.css(".main-rank-description").inner_text
				stopword(hash["content"])
				hash["site_url"] = node.at(".num-item-link").at("a").attribute("href").value
				hash["category"] = "Restaurant"
				hash["category_disp"] = "Restaurant"
				array.push(hash)
			end
		end
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
		   		hash["content"] = node.css('.guide_place_comment20').text #説明文
		   		hash["address"] = node.css('.photo_data').css("p").text.split("：")[1].split("/")[0] #住所
		   		hash["site_url"] = "http://zakka.30min.jp" + node.css('a').attribute('href').value #URL
		   		hash["category"] = "Variety"
		   		hash["category_disp"] = "雑貨店"
		   		geocodeing_api(hash,hash["address"]) unless hash["address"].blank?
		   		array.push(hash)
		   	end
		end
	end

	def feelkobe_scraping(events)
		doc = getDoc("http://www.feel-kobe.jp/event/")
		doc.xpath('//div[@class="inner_box"]').each do |node|
			hash = {}
			hash["category"] = "Feelkobe"
			hash["category_disp"] = "観光Info"
			hash["title"] = node.css("h6").inner_text
			next if hash["title"].blank?
			
			img = node.at(".border")
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
			hash["site_url"] = "http://www.feel-kobe.jp/sp" + content.css("a").attribute("href").value unless content.blank?

			# 続きはこちらの中の説明文を得る
			detail_content = ""
			readFlag = false
			readCount = 0
			detailDoc = getDoc(hash["site_url"]) 
			detailDoc.xpath('//div[@class="inner_box"]').each do |detailNode|
				next if readCount > 0
				detailNode.css("p").each do |pnode|
					# 説明文は<p></p>に囲まれている
					# <p></p> <p>説明文</p><p>説明文</p> <p></p>
					print "!!:#{readCount}:"+pnode.text
					if pnode.text.blank?
						readFlag = readFlag ? false : true
						readCount += 1
						next
					end
					detail_content += pnode.inner_text + "\n" if readFlag
				end
			end
			hash["content"] = detail_content unless detail_content.blank?
			stopword(hash["content"])
			events.push(hash)
		end
	end
	
	def umie_scraping(events)
	    doc = getDoc('http://umie.jp/news/event/')
	    doc.xpath('//div[@class="eventNewsBox"]').each do |node|
	    	hash = {}
	    	hash["category"] = "Umie"
	    	hash["category_disp"] = "Umie"
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
	     	stopword(hash["content"])
	     	link = node.css(".clearfix").css("a")
	     	hash["site_url"] = "http://umie.jp" + link.attribute("href").value unless link.blank?
	     	events.push(hash)
	    end
	end
	
	def sanda_scraping(events)
		# http://www.premiumoutlets.co.jp/kobesanda/events/
	    url = "http://www.premiumoutlets.co.jp"
	    doc = getDoc( url + "/kobesanda/events/")
	    # refUrl: http://white.s151.xrea.com/blog/2008-02-11-10-36.html
	    doc.xpath('//div[contains(concat(" ",normalize-space(@class)," "), " block ")]').each do |node|
	    	hash = {}
	    	hash["category"] = "Sanda"
	    	hash["category_disp"] = "Sanda"
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
	      	stopword(hash["content"])
	      	hash["site_url"] = "http://www.premiumoutlets.co.jp/kobesanda/events/"
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
	        	hash["category"] = "Mitsui"
	        	hash["category_disp"] = "Mitsui"
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
		        hash["content"] = detail[0].inner_text unless url == event_url && detail.blank?
		        hash["content"] = detail[0].inner_text if url == event_url && !detail.blank?
		        stopword(hash["content"]) unless detail.blank?
		        link = node.css(".shop_name").css("a")
		        hash["site_url"] = "http://www.31op.com/kobe/news/event.html" if link.blank?
		        hash["site_url"] = "http://www.31op.com/kobe/news/" + link.attribute("href").value unless link.blank?
		        
		        events.push(hash)
	      	end
	    end
	end

	def stopword(content)
		content.gsub!(/\r\n/,"\n")
		content.gsub!(/\n\t\t|\n\t/,"\n")
		content.gsub!(/\n\n\n|\n\n/,"\n")
		content.gsub!(/\t\t\t|\t\t/,"\t")
		content.gsub!(/続きはこちら/,"ここから消すんだ!")
		content.gsub!(/続きを読む/,"!ここから消すんだ!")
		start_ = content.index("!ここから消すんだ!")
		_end =  content.length+1
		content.slice!(start_.._end) if start_
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

	def get_eventday(content)
		# 正規表現で x月x日（x） or  y/y（y） を取得して，最後の日を開催終了日とする．その値を返す

	end

end