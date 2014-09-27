class BaseShopController < ApplicationController

	# @param: near/category/34-691279/135-183025/1
	def near
		category = params[:category].downcase
		currentlat = params[:latitude].gsub(/(-)/, ".").to_f
		currentlon = params[:longitude].gsub(/(-)/, ".").to_f
		page_num = params[:page].to_i
		
		results = []
		return results unless category or currentlat or currentlon 
		
		address = toAddress(currentlat,currentlon)
		if address.include?("神戸")
			setKobeRestaurantClothing(currentlat,currentlon,page_num,category,results)
		end
		if address.include?("兵庫") && results.blank?
			set50kmKobeInfo(currentlat,currentlon,page_num,category,results)
		end
		if results.blank?
			setKobeInfoList(page_num,category,results)
		end
		results = sort_category(results,["Clothing","Restaurant"])
		render_json(results)
	end

	# http://developer.yahoo.co.jp/webapi/map/openlocalplatform/v1/reversegeocoder.html
	def toAddress(lat,lon)
		base_url = "http://reverse.search.olp.yahooapis.jp/OpenLocalPlatform/V1/reverseGeoCoder?appid="
		appid = "dj0zaiZpPVk0S2lzOW1kZG1ZTiZzPWNvbnN1bWVyc2VjcmV0Jng9YTQ-"
		param = "&lat=#{lat.to_s}&lon=#{lon.to_s}&datum=tky"
		url = base_url + appid + param

		doc = getDoc(url)
		doc.xpath("//property").each do |node|
			return node.css("address").text 
		end
	end

	# TODO:雑貨屋情報を足す

  	# 3km県内のリストが欲しいとき
	def setKobeRestaurantClothing(currentlat,currentlon,pageNum,category,results)
		if category != "restaurant" && category != "clothing" && category != "variety"
			# all カテゴリ
			# TODO:3->5 7->10			
			yahooLocalSearch(currentlat,currentlon,pageNum,5,"clothing",results)
	    	yahooLocalSearch(currentlat,currentlon,pageNum,10-results.length,"restaurant",results)
	    elsif category == "restaurant"
	    	yahooLocalSearch(currentlat,currentlon,pageNum,10,"restaurant",results)
	    elsif category == "clothing"
			yahooLocalSearch(currentlat,currentlon,pageNum,10,"clothing",results)
		elsif category == "variety"
		end
	end

	# 50km県内のリストが欲しいとき:未テスト
	def set50kmKobeInfo(currentlat,currentlon,pageNum,category,results)
		if category != "restaurant" && category != "clothing" && category != "variety"
			# all カテゴリ
			# TODO:3->5 7->10
			yahooLocalSearch(currentlat,currentlon,pageNum,5,"clothing_50km",results)
	    	yahooLocalSearch(currentlat,currentlon,pageNum,10-results.length,"restaurant_50km",results)
	    elsif category == "restaurant"
	    	yahooLocalSearch(currentlat,currentlon,pageNum,10,"restaurant_50km",results)
	    elsif category == "clothing"
			yahooLocalSearch(currentlat,currentlon,pageNum,10,"clothing_50km",results)
		elsif category == "variety"
		end 
	end
	
	# 普通にリストが欲しいとき
	def setKobeInfoList(pageNum,category,results)
		if category != "restaurant" && category != "clothing" && category != "variety"
			# all カテゴリ
			yahooLocalSearch(nil,nil,pageNum,3,"clothing",results)
	    	yahooLocalSearch(nil,nil,pageNum,7-results.length,"restaurant",results)
	    elsif category == "restaurant"
	    	yahooLocalSearch(nil,nil,pageNum,10,"restaurant",results)
	    elsif category == "clothing"
			yahooLocalSearch(nil,nil,pageNum,10,"clothing",results)
		elsif category == "variety"
		end
	end	
	
	def variety

		# here your code
	end
end