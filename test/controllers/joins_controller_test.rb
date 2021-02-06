require 'test_helper'

class JoinsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get joins_new_url
    assert_response :success
  end

  test "should get edit" do
    get joins_edit_url
    assert_response :success
  end

  test "should get show" do
    get joins_show_url
    assert_response :success
  end

end
