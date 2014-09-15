# -*- coding: utf-8 -*-                                                                                 

class EventController < ApplicationController
  
  # getDoc/render_jsonメソッドはApplicationControllerに記述
  
  # /event/list.json
  # イベント一覧情報をJSONで受け渡す
  def list
    # 全件取得して表示
    allEvents = []
    Content.all.map{ |c|
      hash = {:id => c.id , :title => c.title, :image => c.image, :imageFlag => c.imageFlag, :category => c.category}
      allEvents.push(hash)
    }
    allEvents.sort_by{|hash| hash['title']}
    render_json(allEvents)
  end

  def outlet_event(place)
    events = []
    Content.where("category == ?",place).map{ |record|
      hash = {:id => record.id , :title => record.title , :image => record.image , :imageFlag => record.imageFlag , :category => record.category}
      events.push(hash)
    }
    render_json(events)
  end

  # /event/umie.json
  def umie
    outlet_event("umie")
  end

  # /event/sanda.json
  def sanda
    outlet_event("sanda")
  end

  # /event/mitsui.json
  def mitsui
    outlet_event("mitsui")
  end

  # /event/show/:id
  def show
    detail_event = []
    id = params["id"]
    Content.find(id){ |e|
      hash = {
        :id=>e.id,
        :title=>e.title,
        :image=>e.image,
        :imageFlag=>e.imageFlag,
        :category=>e.category,
        :content=>e.content,
        :site_url=>e.site_url
      }
      detail_event.push(hash)
    }
    render_json(detail_event)
  end
end