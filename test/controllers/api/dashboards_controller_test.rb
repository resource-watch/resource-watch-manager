require 'test_helper'

class Api::DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_dashboards_index_url
    assert_response :success
  end

  test "should get show" do
    get api_dashboards_show_url
    assert_response :success
  end

  test "should get create" do
    get api_dashboards_create_url
    assert_response :success
  end

  test "should get update" do
    get api_dashboards_update_url
    assert_response :success
  end

  test "should get destroy" do
    get api_dashboards_destroy_url
    assert_response :success
  end

end
