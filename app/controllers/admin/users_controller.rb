class Admin::UsersController < ApplicationController
  def index
    #今回はuserの数が小さいのでOK、だと思う
    @users = User.includes(order: {order_details: :item})
                 .where(orders: {state: Order.states['ordered']})
  end

  def update
  end

  def destroy
  end
end
