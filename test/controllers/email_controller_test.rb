require 'test_helper'

class EmailControllerTest < ActionController::TestCase
  test "should get send_mail" do
    get :send_mail
    assert_response :success
  end

end
