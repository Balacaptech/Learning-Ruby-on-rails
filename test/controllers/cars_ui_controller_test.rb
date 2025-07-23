require "test_helper"

class CarsUiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cars_ui_index_url
    assert_response :success
  end

  test "should get new" do
    get cars_ui_new_url
    assert_response :success
  end

  test "should get edit" do
    get cars_ui_edit_url
    assert_response :success
  end
end
