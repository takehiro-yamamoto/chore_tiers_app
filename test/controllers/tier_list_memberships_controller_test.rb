require "test_helper"

class TierListMembershipsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get tier_list_memberships_create_url
    assert_response :success
  end

  test "should get destroy" do
    get tier_list_memberships_destroy_url
    assert_response :success
  end
end
