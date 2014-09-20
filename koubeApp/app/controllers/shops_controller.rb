# http://d.hatena.ne.jp/maeharin/20130104/p1
# http://blog.ruedap.com/2011/05/31/ruby-require-load-path
require File.expand_path('../base_shop_controller.rb', __FILE__)

class ShopsController <  BaseShopController
	
	# yahooLocalSearch(currentlat=nil,currentlon=nil,pageNum=1)
  	def list
  		page_num = params[:page]
  		page_num = 1 if params[:page].blank?
		result = yahooLocalSearch(nil,nil,page_num.to_i)
		render_json(result)
  	end

  	# 詳細ページ.雑貨屋情報はどうしよう．
  	def show
  		uid = params[:uid]
  		result = yahooLocalSearchDetail(uid)
  		render_json(result)
  	end
  	
	# 延原さん
=begin
	ここはコメントアウトだよん

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
	メソッド処理の詳細は こちらのファイルを見てね
	/app/controllers/application_controller.rb
	使い方はこちら
	app/controllers/event_controller.rb
	
	動くかテストしたいとき
	rails server コマンドをコマンドプロンプトで実行
	http://localhost:3000/shops/variety をブラウザで見れる
=end
  	def variety
  		super  # 只平さんのコードがここで実行される
  		
  		# here your code

		varieties = []
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
		   		varieties.push(hash)
		   	end
		end
	   	render_json(varieties)
	end

# 延原さんへのアドバイス！

# 実はid はなくても良かった

# =begin =endの中はコメントアウト．その中にコードを書いても実行されない．
# def variety の下に書いてほしかった．実は，here your codeって書いてあった．

# インデントを正確にしましょう．単純に読みにくい．入れ子関係がわかりにくい
# インデントはTabキーで作成します．

# インデント良くない例：
# if hash.blank?
# next # インデントなし
# end

# インデント良い例：
# if hash.blank?
# 	next # インデントあり＝＞読みやすい
# end

# imageFlagが無かったよ．hash["imageFlag"]が欲しかった

# 取得先のurlを二つにしました．


end
