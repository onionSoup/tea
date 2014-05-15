require 'test_helper'

class AdminOrdersControllerTest < ActionController::TestCase
  setup do
    @admin_order = admin_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_order" do
    assert_difference('AdminOrder.count') do
      post :create, admin_order: { time_limit_id: @admin_order.time_limit_id }
    end

    assert_redirected_to admin_order_path(assigns(:admin_order))
  end

  test "should show admin_order" do
    get :show, id: @admin_order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_order
    assert_response :success
  end

  test "should update admin_order" do
    patch :update, id: @admin_order, admin_order: { time_limit_id: @admin_order.time_limit_id }
    assert_redirected_to admin_order_path(assigns(:admin_order))
  end

  test "should destroy admin_order" do
    assert_difference('AdminOrder.count', -1) do
      delete :destroy, id: @admin_order
    end

    assert_redirected_to admin_orders_path
  end
end
