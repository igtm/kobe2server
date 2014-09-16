class BaseShopController < ApplicationController

	# @param: near/34-691279/135-183025/1
	def near
		currentLat = params[:latitude].gsub(/(-)/, ".").to_f
		currentLon = params[:longitude].gsub(/(-)/, ".").to_f
		page_num = params[:page].to_i
		result = yahooLocalSearch(currentLat,currentLon,page_num)
		render_json(result)
	end
	
	# 只平さん担当
=begin
	課題：
	雑貨屋情報のサイトから，以下の情報を取り出してほしい
	title:雑貨屋名（必須）
	content:雑貨屋の説明文
	image:画像のURL(絶対パス)
	imageFlag:画像の有無（true or false）
	site_url:雑貨屋サイトのURL（無ければ空文字を入れる）
	
	取り出したお店の情報はハッシュ（連想配列）に格納すること
	ハッシュに情報格納する際には，category:"variery"も追加で格納すること

	各ハッシュは配列に追加格納していくこと
	
	最後に配列をjson形式で出力し，Webサイトの画面に表示されること
	
	
	課題をこなす際に以下のメソッドを作ったので使っても構いません
	getDoc(string)
	render_json(array)
	メソッド処理の詳細は こちら
	app/controllers/application_controller.rb
	使い方はこちら
	app/controllers/event_controller.rb
=end	
	def variety

		# here your code
	end
end