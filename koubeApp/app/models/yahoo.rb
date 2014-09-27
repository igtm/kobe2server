class Yahoo < ActiveRecord::Base

	scope :search_category, lambda {|events_str|
		events_array = events_str.split(" ")
		sql = ""
		sqls = []
		events_array.each do |event|
			sqls.push("category = '#{event}'")
			sql = sqls.join(" or ")
		end
		where(sql)
	}	

end
