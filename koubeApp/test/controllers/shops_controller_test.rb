require 'test_helper'

class ShopsControllerTest < ActionController::TestCase
  test "should get near" do
    get :near
    assert_response :success
  end

  test "should get list" do
    get :list
    assert_response :success
  end

end
