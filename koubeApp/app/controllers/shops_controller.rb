# http://d.hatena.ne.jp/maeharin/20130104/p1
# http://blog.ruedap.com/2011/05/31/ruby-require-load-path
require File.expand_path('../base_shop_controller.rb', __FILE__)


class ShopsController <  BaseShopController
  # 只平さん担当
  def list
  	yahooLocalSearch(34.694563,135.195247)
  end
end
