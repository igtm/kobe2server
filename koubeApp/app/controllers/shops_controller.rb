# http://d.hatena.ne.jp/maeharin/20130104/p1
# http://blog.ruedap.com/2011/05/31/ruby-require-load-path
require File.expand_path('../base_shop_controller.rb', __FILE__)

class ShopsController <  BaseShopController
     
  # yahooLocalSearch(currentlat=nil,currentlon=nil,pageNum=1,category_type,results)
    def list
      page_num = params[:page]
      page_num = 1 if params[:page].blank?
      page_num = page_num.to_i
      results = []
      if page_num <= 2
        results = getYahooDB("list","Restaurant Clothing",page_num)
        variety_scraping(results,page_num,3)
        results = sort_category_list(results,["Restaurant","Clothing","Variety"])
        render_json(results)
        return        
      end

      # +3clothing +4restaurant
      setKobeInfoList(page_num,"all",results)
      # +3shop
      variety_scraping(results,page_num.to_i,3)
      # 合計10ショップ
      results = sort_category_list(results,["Restaurant","Clothing","Variety"])
      render_json(results)
    end
    
    # お店の詳細ページ
    def show
      uid = params[:uid] 
      uid_i = uid.to_i
      if uid_i == 0 or uid.length > 15 # 'jfla208402'.to_i = 0
        # Yahoo
        result = yahooLocalSearchDetail(uid)
        render_json(result)
        return
      else
        # DB
        variety = Content.find(uid)
        # http://d.hatena.ne.jp/favril/20100604/1275668631
        hash = variety.attributes
        hash["uid"] = hash["id"]
        render_json(hash)
      end
    end

    # レストラン情報のみ表示
    def restaurant
      page_num = params[:page].blank? ? 1 : params[:page].to_i
      results = []
      if page_num <= 1
        results = getYahooDB("only","Restaurant",page_num)
        render_json(results)
        return
      end
      
      setKobeInfoList(page_num,"restaurant",results)
      # gurume_rank_scraping(results,page_num,3)
      results = exchange(results)
      results = addRank(results) if page_num == 1 # 1~3位にランク付け 
      render_json(results)
    end

    # @db_output="list"/"only"
    # @_category="Restaurant"/"Clothing"/
    def getYahooDB(db_output,_category,page_num)
      results = []
      page_size = 10
      page_size = 7 if db_output == "list"
      
      yahoo = Yahoo.search_category(_category).where("db_output == ?",db_output)
      yahoo = yahoo.order("rate DESC") if _category == "Restaurant"
      
      count = 0
      yahoo.limit(page_size).offset(page_size * (page_num-1)).map{ |e|
        hash = {"uid"=>e.uid,"title"=>e.title,"imageFlag"=>e.imageFlag,"image"=>e.image,
            "category"=>e.category,"categoryDetail"=>e.categoryDetail,"category_disp"=>e.category_disp,"rate"=>e.rate,
            "shoplat"=>e.shoplat,"shoplon"=>e.shoplon}
        #rankある場合のみ
        if _category == "Restaurant" && count <= 2
          count += 1
          hash["rank"] = count
        end
        results.push(hash)
      }
      return results
    end

    # 食事オシャレお店のスクレイピング
    def gurume_rank_scraping(array,page_num=1,page_size=3)
      # page_num = page_num.to_i
      # # ここでDBからゲットしてarrayにpushする
      # Content.search_category("Restaurant").limit(page_size).offset(page_size * (page_num-1)).map { |e| 
      #   hash = {"uid" => e.id , "title" => e.title, "image" => e.image, "imageFlag" => e.imageFlag, "category" => e.category}
      #   array.push(hash)
      # }
    end

    # ファッションや洋服店の情報のみ表示
    def clothing
      page_num = params[:page].blank? ? 1 : params[:page].to_i
      results = []
      if page_num <= 2
        results = getYahooDB("only","Clothing",page_num)
        render_json(results)
        return
      end

      yahooLocalSearch(nil,nil,page_num,10,"clothing",results)
      render_json(results)
    end

    # 雑貨屋をスクレイピング
    def variety_scraping(array,_page_num=1,page_size=3)
      page_num = _page_num.to_i
      Content.search_category("Variety").limit(page_size).offset(page_size * (page_num-1)).map { |e| 
        hash = {"uid" => e.id , "title" => e.title, "image" => e.image, "imageFlag" => e.imageFlag, "category" => e.category,"category_disp" => e.category_disp}
        array.push(hash)
      }
    end
    
    # 雑貨屋
    def variety
      allVarieties = []
      page_num = params["page"] == nil ? 1 : params["page"].to_i # 3項演算子
      page_size = 10
      variety_scraping(allVarieties,page_num,page_size)
      allVarieties.sort_by{|hash| hash['title']}
      render_json(allVarieties)
    end
    
    #個々の雑貨屋情報を表示
    def variety_show
      id = params[:id].to_i
      variety = Content.find(id)
      # http://d.hatena.ne.jp/favril/20100604/1275668631
      hash = variety.attributes
      hash["uid"] = hash["id"]
      render_json(hash)
    end

end
