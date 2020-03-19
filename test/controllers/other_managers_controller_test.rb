require 'test_helper'

class OtherManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @other_manager = other_managers(:one)
  end

  test "should get index" do
    get other_managers_url
    assert_response :success
  end

  test "should get new" do
    get new_other_manager_url
    assert_response :success
  end

  test "should create other_manager" do
    assert_difference('OtherManager.count') do
      post other_managers_url, params: { other_manager: { employee_id: @other_manager.employee_id, type: @other_manager.type } }
    end

    assert_redirected_to other_manager_url(OtherManager.last)
  end

  test "should show other_manager" do
    get other_manager_url(@other_manager)
    assert_response :success
  end

  test "should get edit" do
    get edit_other_manager_url(@other_manager)
    assert_response :success
  end

  test "should update other_manager" do
    patch other_manager_url(@other_manager), params: { other_manager: { employee_id: @other_manager.employee_id, type: @other_manager.type } }
    assert_redirected_to other_manager_url(@other_manager)
  end

  test "should destroy other_manager" do
    assert_difference('OtherManager.count', -1) do
      delete other_manager_url(@other_manager)
    end

    assert_redirected_to other_managers_url
  end
end
