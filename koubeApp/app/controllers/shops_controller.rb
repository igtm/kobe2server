# http://d.hatena.ne.jp/maeharin/20130104/p1
# http://blog.ruedap.com/2011/05/31/ruby-require-load-path
require File.expand_path('../base_shop_controller.rb', __FILE__)

class ShopsController <  BaseShopController
	
  	def list
  		yahooLocalSearch(34.694563,135.195247)
  	end
  	
	# 延原さん
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
  	end
end
