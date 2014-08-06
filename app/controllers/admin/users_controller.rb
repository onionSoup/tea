class Admin::UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save!

    redirect_to :admin_users
  rescue ActiveRecord::RecordInvalid => e
    render :new
  end

  def index
    @users = User.includes(:order)
  end

  def edit
  end

  def update
  end

  def destroy
    @user = User.find(params[:id])

    if @user.order_details.any?
      flash[:error] = 'この商品を使った注文情報があるので、削除できません。'
    else
      User.destroy @item
    end

    redirect_to :admin_items
  end

  def user_params()
    params.require(:user).permit(:name)
  end
end
