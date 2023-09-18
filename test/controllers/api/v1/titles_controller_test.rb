require "test_helper"

class Api::V1::TitlesControllerTest < ActionDispatch::IntegrationTest
  test "should get api/v1/TeamMembers" do
    get api_v1_titles_api/v1/TeamMembers_url
    assert_response :success
  end
end
