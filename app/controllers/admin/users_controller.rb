class Admin::UsersController < ApplicationController
  include Signin
  before_action :need_signed_in
  before_action :reject_destroy_when_signined, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save!

    redirect_to :admin_users, flash: {success: "#{@user.name}を登録しました。"}
  rescue ActiveRecord::RecordInvalid => e
    render :new
  end

  def index
    @users = User.order(:id)
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
      User.destroy @user #if @user == current_user
    end

    redirect_to :admin_items
  end

  private

  def user_params()
    params.require(:user).permit(:name)
  end

  def reject_destroy_when_signined
    user = User.find(params[:id])
    return unless user == current_user
    redirect_to admin_users_path, flash: {error: "#{user.name}さん自身を削除することはできません。"}
  end
end
