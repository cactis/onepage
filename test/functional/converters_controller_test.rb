require 'test_helper'

class ConvertersControllerTest < ActionController::TestCase
  test "should get html2haml" do
    get :html2haml
    assert_response :success
  end

  test "should get haml2html" do
    get :haml2html
    assert_response :success
  end

end
