class BaseShopController < ApplicationController

	# @param: near/34-691279/135-183025/1
	def near
		currentlat = params[:latitude].gsub(/(-)/, ".").to_f
		currentlon = params[:longitude].gsub(/(-)/, ".").to_f
		page_num = params[:page].to_i
		results = []
		return results unless currentlat || currentlon 
		
		address = toAddress(currentlat,currentlon)
		if address.include?("神戸")
			setKobeRestaurantClothing(currentlat,currentlon,page_num,results)
		end
		if address.include?("兵庫") && results.blank?
			set50kmKobeInfo(currentlat,currentlon,page_num,results)
		end
		if results.blank?
			setKobeInfoList(page_num,results)
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

  	# 3km県内のリストが欲しいとき
	def setKobeRestaurantClothing(currentlat,currentlon,pageNum,results)
		yahooLocalSearch(currentlat,currentlon,pageNum,3,"clothing",results)		
	    yahooLocalSearch(currentlat,currentlon,pageNum,7-results.length,"restaurant",results)
	end

	# 50km県内のリストが欲しいとき
	def set50kmKobeInfo(currentlat,currentlon,pageNum,results)
	    yahooLocalSearch(currentlat,currentlon,pageNum,3,"clothing_50km",results)
	    yahooLocalSearch(currentlat,currentlon,pageNum,7-results.length,"restaurant_50km",results)		
	    return results
	end

	# 普通にリストが欲しいとき
	def setKobeInfoList(pageNum,results)
		yahooLocalSearch(nil,nil,pageNum,3,"clothing",results)		
		yahooLocalSearch(nil,nil,pageNum,7-results.length,"restaurant",results)
	end	
	
	def variety

		# here your code
	end
end