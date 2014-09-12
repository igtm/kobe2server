require 'test_helper'

class DatabaseControllerTest < ActionController::TestCase
  test "should get update" do
    get :update
    assert_response :success
  end

end
