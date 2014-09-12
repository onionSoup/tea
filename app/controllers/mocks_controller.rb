class MocksController < ApplicationController
  include Login

  before_action :need_logged_in

  def show
    @order = User.includes(order: {order_details: :item}).find(current_user).order
    @items = Item.order(:id)
  end
end
