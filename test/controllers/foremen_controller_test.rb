require 'test_helper'

class ForemenControllerTest < ActionDispatch::IntegrationTest
  setup do
    @foreman = foremen(:one)
  end

  test "should get index" do
    get foremen_url
    assert_response :success
  end

  test "should get new" do
    get new_foreman_url
    assert_response :success
  end

  test "should create foreman" do
    assert_difference('Foreman.count') do
      post foremen_url, params: { foreman: { employee_id: @foreman.employee_id } }
    end

    assert_redirected_to foreman_url(Foreman.last)
  end

  test "should show foreman" do
    get foreman_url(@foreman)
    assert_response :success
  end

  test "should get edit" do
    get edit_foreman_url(@foreman)
    assert_response :success
  end

  test "should update foreman" do
    patch foreman_url(@foreman), params: { foreman: { employee_id: @foreman.employee_id } }
    assert_redirected_to foreman_url(@foreman)
  end

  test "should destroy foreman" do
    assert_difference('Foreman.count', -1) do
      delete foreman_url(@foreman)
    end

    assert_redirected_to foremen_url
  end
end
