# -*- coding: utf-8 -*-                                               

class EventController < ApplicationController
  # getDoc/render_jsonメソッドはApplicationControllerに記述
  # /event/list/2.json
  # イベント一覧情報をJSONで受け渡す
  def list
    # 10ずつ表示
    allEvents = []
    page_num = params["page"] == nil ? 1 : params["page"].to_i
    page_size = 10
    
    Content.search_category("Umie Sanda Mitsui Feelkobe").limit(page_size).offset(page_size * (page_num-1)).map { |e| 
      hash = {"eventid" => e.id , "title" => e.title, "image" => e.image, "imageFlag" => e.imageFlag, "category" => e.category , "category_disp" => e.category_disp}
      allEvents.push(hash)
    }
    allEvents.sort_by{|hash| hash['title']}
    allEvents = sort_category(allEvents,["Feelkobe","Umie","Sanda","Mitsui"])
    render_json(allEvents)
  end
  
  def outlet_event(place,page_num)
    #10件ずつ表示
    page_size = 10
    events = []

    Content.where("category == ?",place).limit(page_size).offset(page_size * (page_num-1)).map{ |record|
      hash = {"eventid" => record.id, "title" => record.title, "image" => record.image, "imageFlag" => record.imageFlag, "category" => record.category,"category_disp" => record.category_disp}
      events.push(hash)
    }
    render_json(events)
  end
  
  # /event/umie.json
  def umie
    page_num = params["page"] == nil ? 1 : params["page"].to_i
    outlet_event("Umie",page_num)
  end
  
  # /event/sanda.json
  def sanda
    page_num = params["page"] == nil ? 1 : params["page"].to_i
    outlet_event("Sanda",page_num)
  end
  
  # /event/mitsui.json
  def mitsui
    page_num = params["page"] == nil ? 1 : params["page"].to_i
    outlet_event("Mitsui",page_num)
  end
  
  # /event/show/:id
  def show
    id = params["id"].to_i
    aContent = Content.find(id)
    # http://d.hatena.ne.jp/favril/20100604/1275668631
    hash = aContent.attributes
    hash["eventid"] = hash["id"]
    render_json(hash)
  end

  # def error_page(page_size,page_num)
  #   if Content.count + page_size*2 < page_size * page_num
  #     return true
  #   end
  #   return false
  # end
end