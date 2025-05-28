require "test_helper"

class TierListsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tier_lists_index_url
    assert_response :success
  end

  test "should get new" do
    get tier_lists_new_url
    assert_response :success
  end

  test "should get create" do
    get tier_lists_create_url
    assert_response :success
  end

  test "should get show" do
    get tier_lists_show_url
    assert_response :success
  end

  test "should get edit" do
    get tier_lists_edit_url
    assert_response :success
  end

  test "should get update" do
    get tier_lists_update_url
    assert_response :success
  end

  test "should get destroy" do
    get tier_lists_destroy_url
    assert_response :success
  end

  test "should get edit_tiers" do
    get tier_lists_edit_tiers_url
    assert_response :success
  end

  test "should get update_tiers" do
    get tier_lists_update_tiers_url
    assert_response :success
  end
end
