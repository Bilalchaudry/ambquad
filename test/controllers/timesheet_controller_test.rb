require 'test_helper'

class TimesheetControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get timesheet_index_url
    assert_response :success
  end

end
