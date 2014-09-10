# -*- coding: utf-8 -*-
require "open-uri"
class EventController < ApplicationController
  # /event/index
  # イベント一覧情報をJSONで受け渡す
  def list
    test_url = "http://4804c19e.ngrok.com/umie.rb"
    json_data = open(test_url).read    
    response.headers['Content-Type'] = 'application/javascript; charset=utf-8'
    callback_method = params[:callback]
    respond_to do |format|
      format.html
      format.json {  render :json => json_data,callback: callback_method}
      end
  end
  # /event/show/11 
  def show
  end
end
