require 'test_helper'

class MeetupEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get meetup_events_index_url
    assert_response :success
  end

end
