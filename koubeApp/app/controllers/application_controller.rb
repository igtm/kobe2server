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
  def yahooLocalSearch(currentlat=nil,currentlon=nil,pageNum=1)
    # urlを用意（lat,lon,dist=18,）or 神戸検索
  	# 　Yahooにopen.readする（XML取得する） OK?
    # 各お店の位置と現在地からURLを用意
    # 　二点間距離を取得
    # 各お店のuidでURLを用意
    # 　口コミを取得
    # "http://search.olp.yahooapis.jp/OpenLocalPlatform/V1/localSearch?appid=dj0zaiZpPVk0S2lzOW1kZG1ZTiZzPWNvbnN1bWVyc2VjcmV0Jng9YTQ-&ac=28100&sort=rating"
    base_url = "http://search.olp.yahooapis.jp/OpenLocalPlatform/V1/localSearch?appid="
    appid = "dj0zaiZpPVk0S2lzOW1kZG1ZTiZzPWNvbnN1bWVyc2VjcmV0Jng9YTQ-"
    # http://www13.plala.or.jp/bigdata/municipal_code_2.html
    position = "&ac=28100&sort=rating"
    position = "&lat="+currentlat.to_s+"&lon="+currentlon.to_s+"&dist=3&sort=hybrid" if currentlat != nil && currentlon != nil
    category = "0102,0103,0104009,0105,0107002,0107004,0110005,0110006,0112,0113,0115,0116,0117,0118,0119,0122,0123003,0125,0127,0209,0210006,0210009"
    param = "&gc="+category+"&results=10&start="+((pageNum-1)*10).to_s
    local_search_url = base_url + appid + position + param

    doc = getDoc(local_search_url)

    shops = []
    print doc
    doc.xpath('//feature').each do |node|
      hash = {}
      hash["title"] = node.at("name").inner_text
      hash["category"] = node.at('category').inner_text
      lon_lat = node.at("coordinates").inner_text.split(",")
      hash["shoplon"] = lon_lat[0]
      hash["shoplat"] = lon_lat[1]
      hash["address"] = node.at("address").inner_text
      hash["tel"] = node.at("tel1").inner_text

      lead_image = node.at("leadimage")
      hash["image"] = lead_image.inner_text unless lead_image.blank?
      hash["imageFlag"] = true
      hash["imageFlag"] = false if hash["image"] == ""
      hash["uid"] = node.at("uid").inner_text
      
      coupon_flag = node.at("couponflag")
      coupon_flag = node.at("couponflag").inner_text if coupon_flag
      hash["couponFlag"] = node.at("couponflag").inner_text unless coupon_flag.blank?
      hash["coupon_url"] = node.at("coupon").at("pcurl").inner_text unless coupon_flag.blank?
      mobile_url_flag = node.at("coupon").at("mobileflag").inner_text unless coupon_flag.blank?      
      hash["coupon_url"] = node.at('coupon').at('mobileurl').inner_text unless mobile_url_flag.blank?
      
      hash["distance_km"] = getDistance(currentlat,currentlon,hash["shoplat"],hash["shoplon"])
      #hash["reivew"] = getReview(hash["uid"]) if key == "review"
      shops.push(hash)
    end

    return shops

  end

=begin
    http://developer.yahoo.co.jp/webapi/map/openlocalplatform/v1/distance.html
    ２点間距離を取得
    http://stackoverflow.com/questions/8709532/ruby-rails-bad-uri
=end
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

=begin
    http://developer.yahoo.co.jp/webapi/map/openlocalplatform/v1/reviewsearch.html
    UIDから口コミを取得
    今回は未使用．今後使う可能性あり
=end
  def getReview(uid)
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
