class BaseShopController < ApplicationController

	# @param: near/34-691279/135-183025/1
	def near
		currentLat = params[:latitude].gsub(/(-)/, ".").to_f
		currentLon = params[:longitude].gsub(/(-)/, ".").to_f
		page_num = params[:page].to_i
		results = []
		yahooLocalSearch(currentLat,currentLon,page_num,"all",results)
		if results.blank?
			hash = {:error_message=>"Error: user is not in Kobe"}
			results.push(hash)
			yahooLocalSearch(nil,nil,page_num,"all",results)
		end
		render_json(results)
	end
		
	def variety

		# here your code
	end
end