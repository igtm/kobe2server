require "open-uri"
require "parallel"
# http://morizyun.github.io/blog/parallel-process-ruby-gem/

class ApplicationController < ActionController::Base

  # JSONPの実装に必要なコード
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :set_access_control_headers
  
  def set_access_control_headers 
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end

  # HTML解析に使うメソッド（getDoc, render_json）
  def getDoc(url)
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す                  
    end
    print "charset="+charset
    charset = "utf-8" if charset == "iso-8859-1"
    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, charset)
    return doc
  end
  
  def render_json(json_data)
    response.headers['Content-Type'] = 'application/javascript; charset=utf-8'
    callback_method = params[:callback]
    respond_to do |format|
      format.html
      format.json {  render :json => json_data,callback: callback_method}
    end
  end

=begin
    http://developer.yahoo.co.jp/webapi/map/openlocalplatform/v1/localsearch.html
    店・雑貨屋・レストランの取得
    YahooLocalSearch
    @param:現在地（latitude,longitude）& 
    @return:お店一覧
=end
  def yahooLocalSearch(currentlat=nil,currentlon=nil,pageNum=1,category_type="all")
    # urlを用意（lat,lon,dist=18,）or 神戸検索
    # 　Yahooにopen.readする（XML取得する） OK?
    # 各お店の位置と現在地からURLを用意
    # 　二点間距離を取得
    # 各お店のuidでURLを用意
    # 　口コミを取得
    # "http://search.olp.yahooapis.jp/OpenLocalPlatform/V1/localSearch?appid=dj0zaiZpPVk0S2lzOW1kZG1ZTiZzPWNvbnN1bWVyc2VjcmV0Jng9YTQ-&gc=0209&ac=28100"
    base_url = "http://search.olp.yahooapis.jp/OpenLocalPlatform/V1/localSearch?appid="
    appid = "dj0zaiZpPVk0S2lzOW1kZG1ZTiZzPWNvbnN1bWVyc2VjcmV0Jng9YTQ-"
    # http://www13.plala.or.jp/bigdata/municipal_code_2.html
    position = "&ac=28100&sort=rating"
    position = "&lat="+currentlat.to_s+"&lon="+currentlon.to_s+"&dist=3&sort=hybrid" if currentlat != nil && currentlon != nil
    gurume_category = "0102,0103,0104009,0105,0107002,0107004,0110005,0110006,0112,0113,0115,0116,0117,0118,0119,0122,0123003,0125,0127"
    fashion_category = "0209001,0209002,0209003,0209005,0209006,0209008,0209009,0209010,0209011,0209012,0209013,0209014,0209016,0209018,0210006,0210009"
    category = gurume_category + "," + fashion_category if category_type == "all"
    category = gurume_category if category_type == "restaurant"
    category = fashion_category if category_type == "clothing"
    param = "&gc="+category+"&results=10&start="+((pageNum-1)*10).to_s
    local_search_url = base_url + appid + position + param

    doc = getDoc(local_search_url)
    shops = []
    doc.xpath('//feature').each do |node|
      hash = {}
      hash["title"] = node.at("name").inner_text
      category_detail = ""
      node.css("genre").each{|genre|
        category_detail += genre.css("name").inner_text
        category_detail += "、"
      }
      hash["categoryDetail"] = category_detail
      # category = RestaurantかClothingかVariety(雑貨屋)
      # Clothing 以外はレストラン．その他に雑貨屋情報を追加
      hash["category"] = getCategory(hash["categoryDetail"])

      lon_lat = node.at("coordinates").inner_text.split(",")
      hash["shoplon"] = lon_lat[0]
      hash["shoplat"] = lon_lat[1]

      lead_image = node.at("leadimage")
      hash["image"] = lead_image.inner_text unless lead_image.blank?
      hash["imageFlag"] = true
      hash["imageFlag"] = false if hash["image"] == ""
      hash["uid"] = node.at("uid").inner_text
      
      hash["distance_km"] = getDistance(currentlat,currentlon,hash["shoplat"],hash["shoplon"])

      shops.push(hash)
    end
    return shops
  end

  def yahooLocalSearchDetail(uid,currentlat=nil,currentlon=nil)
    
    # "http://search.olp.yahooapis.jp/OpenLocalPlatform/V1/localSearch?appid=dj0zaiZpPVk0S2lzOW1kZG1ZTiZzPWNvbnN1bWVyc2VjcmV0Jng9YTQ-&uid=35f10a49835b51ba693970ac81f6d9b6211a2276
    base_url = "http://search.olp.yahooapis.jp/OpenLocalPlatform/V1/localSearch?appid="
    appid = "dj0zaiZpPVk0S2lzOW1kZG1ZTiZzPWNvbnN1bWVyc2VjcmV0Jng9YTQ-"
    # http://www13.plala.or.jp/bigdata/municipal_code_2.html
    param = "&uid="+uid
    local_search_url = base_url + appid + param

    doc = getDoc(local_search_url)
    shops = []
    doc.xpath('//feature').each do |node|
      hash = {}

      # タイトル
      hash["title"] = node.at("name").inner_text

      # カテゴリ
      category_detail = ""
      node.css("genre").each{|genre|
        category_detail += genre.css("name").inner_text
        category_detail += "、"
      }
      hash["categoryDetail"] = category_detail
      hash["category"] = getCategory(hash["categoryDetail"])

      # 位置情報と住所，電話番号
      lon_lat = node.at("coordinates").inner_text.split(",")
      hash["shoplon"] = lon_lat[0]
      hash["shoplat"] = lon_lat[1]
      hash["address"] = node.at("address").inner_text
      hash["tel"] = node.at("tel1").inner_text
      
      # 駅
      node.xpath('//station').each do |station|
        station_name = station.at("name").inner_text
        railway_name = station.at("railway").inner_text
        hash["station_name"] = station_name + "駅"
        hash["station_railway"] = railway_name
      end
      
      # areaの取得がなぜか困難
      node.xpath('//area').each do |test|
        print test
      end
      
      # 詳細説明 存在してること自体少ない
      

      # 画像
      lead_image = node.at("leadimage")
      hash["image"] = lead_image.inner_text unless lead_image.blank?
      hash["imageFlag"] = true
      hash["imageFlag"] = false if hash["image"] == ""

      # 距離
      hash["distance_km"] = getDistance(currentlat,currentlon,hash["shoplat"],hash["shoplon"]) if currentlat || currentlon

      # クーポン
      coupon_flag = node.at("couponflag")
      coupon_flag = coupon_flag.inner_text if coupon_flag
      hash["couponFlag"] = false
      hash["couponFlag"] = coupon_flag if coupon_flag
      unless hash["couponFlag"]
        shops.push(hash)
        next
      end
      coupon = node.at("coupon")
      coupon_name = coupon.at("name")
      coupon_pcurl = coupon.at("pocurl")
      coupon_mobileflag = coupon.at("mobileflag")
      coupon_mobileurl = coupon.at('mobileurl')
      hash["couponName"] = coupon_name unless coupon_name.blank?
      hash["couponUrl"] = coupon_pcurl unless coupon_pcurl.blank?
      mobile_url_flag = coupon_mobileflag unless coupon_mobileflag.blank?
      hash["couponUrl"] = coupon_mobileurl if mobile_url_flag

      hash["reivew"] = getReview(uid)

      shops.push(hash)
    end
    return shops
  end

  def getCategory(detail_category)
    # http://category.search.olp.yahooapis.jp/OpenLocalPlatform/V1/genreCode?appid=dj0zaiZpPVk0S2lzOW1kZG1ZTiZzPWNvbnN1bWVyc2VjcmV0Jng9YTQ-
    category = getAnCategory("0209","Clothing",detail_category)
    return category if category
    # category = getAnCategory("0209016","雑貨屋",detail_category)
    # return category if category
    # category = getAnCategory("0209018","雑貨屋",detail_category)
    # return category if category
    return "Restaurant"
  end

  def getAnCategory(gcCode,expect_category,search_category)
    base_url = "http://category.search.olp.yahooapis.jp/OpenLocalPlatform/V1/genreCode?appid="
    appid = "dj0zaiZpPVk0S2lzOW1kZG1ZTiZzPWNvbnN1bWVyc2VjcmV0Jng9YTQ-"
    param = "&gc="+gcCode
    category_url = base_url + appid + param
    doc = getDoc(category_url)
    doc.xpath('//feature').each do |node|
      category_name = node.css("name").inner_text
      return expect_category if search_category.include?(category_name)
    end
    return false
  end

  # http://developer.yahoo.co.jp/webapi/map/openlocalplatform/v1/distance.html
  # ２点間距離を取得
  # http://stackoverflow.com/questions/8709532/ruby-rails-bad-uri

  def getDistance(currentlat,currentlon,shoplat,shoplon)

    return false if currentlat == nil

    base_url = "http://distance.search.olp.yahooapis.jp/OpenLocalPlatform/V1/distance?appid="
    appid = "dj0zaiZpPVk0S2lzOW1kZG1ZTiZzPWNvbnN1bWVyc2VjcmV0Jng9YTQ-"
    position = "&coordinates="+currentlon.to_s + "," + currentlat.to_s + "%20" + shoplon + "," + shoplat
    distance_url = base_url + appid + position
    
    doc = getDoc(distance_url)
    doc.xpath('//feature').each do |node|
       return node.at("distance").inner_text
    end
    return false
  end

  # http://developer.yahoo.co.jp/webapi/map/openlocalplatform/v1/reviewsearch.html
  # UIDから口コミを取得
  # 今回は未使用．今後使う可能性あり
  def getReview(uid)
    # http://api.olp.yahooapis.jp/v1/review/
    base_url = "http://api.olp.yahooapis.jp/v1/review/" + uid + "?appid="
    appid = "dj0zaiZpPVk0S2lzOW1kZG1ZTiZzPWNvbnN1bWVyc2VjcmV0Jng9YTQ-"
    param = "&results=2&start=1"
    review_url = base_url + appid + param

    reviews = []
    doc = getDoc(review_url)
    doc.xpath('//feature').each do |node|
      hash = Hash.new
      hash[:subject => node.at("subject").inner_text]
      hash[:body => node.at("comment").inner_text]
      hash[:rate => node.at("rating").inner_text.to_i]
      reviews.push(hash)
    end
    return reviews
  end

end