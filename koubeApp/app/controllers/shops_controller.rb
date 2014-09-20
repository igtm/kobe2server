# http://d.hatena.ne.jp/maeharin/20130104/p1
# http://blog.ruedap.com/2011/05/31/ruby-require-load-path
require File.expand_path('../base_shop_controller.rb', __FILE__)

class ShopsController <  BaseShopController
	
	# yahooLocalSearch(currentlat=nil,currentlon=nil,pageNum=1)
  	def list
  		page_num = params[:page]
  		page_num = 1 if params[:page].blank?
		result = yahooLocalSearch(nil,nil,page_num.to_i,"all")
		render_json(result)
  	end

  	# お店の詳細ページ.
  	def show
  		uid = params[:uid]
  		result = yahooLocalSearchDetail(uid)
  		render_json(result)
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
		variety_detail = []
		id = params[:id].to_i
	    variety = Variety.find(id)
	    # http://d.hatena.ne.jp/favril/20100604/1275668631
	    hash = variety.attributes
	    hash["varietyid"] = hash["id"]
	    variety_detail.push(hash)
	    render_json(variety_detail)
	end



# 延原さんへのアドバイス！

# 実はhash["id"] はなくても良かった

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
