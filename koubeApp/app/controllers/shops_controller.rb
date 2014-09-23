# http://d.hatena.ne.jp/maeharin/20130104/p1
# http://blog.ruedap.com/2011/05/31/ruby-require-load-path
require File.expand_path('../base_shop_controller.rb', __FILE__)

class ShopsController <  BaseShopController
	
	# yahooLocalSearch(currentlat=nil,currentlon=nil,pageNum=1)
  	def list
  	  page_num = params[:page]
  		page_num = 1 if params[:page].blank?

      results = []
      variety_scraping(results,page_num.to_i) # +3shop
		  yahooLocalSearch(nil,nil,page_num.to_i,"all",results) #+7shop
      # 合計10ショップ
      
		  render_json(results)
  	end

  	# お店の詳細ページ.
  	def show
  	  uid = params[:uid] 
      if uid.to_i == 0 # 'jfla208402'.to_i = 0
        # Yahoo
        result = yahooLocalSearchDetail(uid)
  		  render_json(result)
        return
      else
        # DB 
        variety = Variety.find(uid)
        # http://d.hatena.ne.jp/favril/20100604/1275668631
        hash = variety.attributes
        hash["uid"] = hash["id"]
        render_json(hash)
      end        
  	end

    # 雑貨屋をスクレイピング
    def variety_scraping(array,_page_num)
      page_num = _page_num == nil ? 1 : _page_num.to_i # 3項演算子
      page_size = 3 # 残り7はYahooから
      Variety.limit(page_size).offset(page_size * (page_num-1)).map { |e| 
        hash = {:uid => e.id , :title => e.title, :image => e.image, :imageFlag => e.imageFlag, :category => e.category}
        array.push(hash)
      }
    end    

  	# 延原・只平さんが記述したコードはdatabase_controller.rbに移動しました
  	
  	# 雑貨屋
  	def variety
  		allVarieties = []
    	page_num = params["page"] == nil ? 1 : params["page"].to_i # 3項演算子
    	page_size = 10
    	Variety.limit(page_size).offset(page_size * (page_num-1)).map { |e| 
	    	hash = {:varietyid => e.id , :title => e.title, :image => e.image, :imageFlag => e.imageFlag, :category => e.category}
	    	allVarieties.push(hash)
    	}
	    allVarieties.sort_by{|hash| hash['title']}
    	render_json(allVarieties)
	end
  
	#個々の雑貨屋情報を表示
	def variety_show
    id = params[:id].to_i
    variety = Variety.find(id)
    # http://d.hatena.ne.jp/favril/20100604/1275668631
    hash = variety.attributes
    hash["varietyid"] = hash["id"]
    render_json(hash)
	end

end
