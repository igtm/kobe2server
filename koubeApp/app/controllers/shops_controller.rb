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
  	
	# 延原さん
=begin

require 'rubygems'
require 'open-uri'
require 'nokogiri'
require "json"

 def render_json(json_data)
  response.headers['Content-Type'] = 'application/javascript; charset=utf-8'
  callback_method = params[:callback]
end

url = 'http://zakka.30min.jp/hyogo/'
i=1
hash = Hash.new

    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す                        
    end

    charset = "utf-8" if charset == "iso-8859-1"

    doc = Nokogiri::HTML.parse(html, nil, charset)
    doc.xpath('//div[@class="thumbnail304"]').each do |node|
   hash["id"]=i
   hash["title"] = node.css('h2').inner_text #店名
   hash["image"] = node.css('img').attribute('src').value #画像のURL
   hash["content"] = node.xpath('//p[@class="guide_place_comment20"]').text #説明文
   hash["URL"] = node.css('a').attribute('href').value#URL
i=i+1

p hash


end

#render_json(hash)

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
