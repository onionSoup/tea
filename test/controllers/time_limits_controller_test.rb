require 'test_helper'

class TimeLimitsControllerTest < ActionController::TestCase
  setup do
    @time_limit = time_limits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:time_limits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create time_limit" do
    assert_difference('TimeLimit.count') do
      post :create, time_limit: { end: @time_limit.end, start: @time_limit.start }
    end

    assert_redirected_to time_limit_path(assigns(:time_limit))
  end

  test "should show time_limit" do
    get :show, id: @time_limit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @time_limit
    assert_response :success
  end

  test "should update time_limit" do
    patch :update, id: @time_limit, time_limit: { end: @time_limit.end, start: @time_limit.start }
    assert_redirected_to time_limit_path(assigns(:time_limit))
  end

  test "should destroy time_limit" do
    assert_difference('TimeLimit.count', -1) do
      delete :destroy, id: @time_limit
    end

    assert_redirected_to time_limits_path
  end
end
