class Admin::UsersController < ApplicationController
  include Signin
  before_action :need_signed_in
  before_action :reject_destroy_self, only: [:destroy]
  before_action :reject_destroy_when_nonblank_detail, only: [:destroy]
  before_action :reject_update_giving_self_name, only: [:update]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.save!

    redirect_to :admin_users, flash: {success: "#{@user.name}さんを登録しました。"}
  rescue ActiveRecord::RecordInvalid => e
    render :new
  end

  def index
    @users = User.order(:id)
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update(user_params)
      redirect_to admin_users_path, flash: {success: "名前を#{@user.name}さんに変更しました。"}
    else
      redirect_to edit_admin_user_path(@user), flash: {error: @user.errors.messages.values.flatten.first}
    end
  end

  def destroy
    user = User.find params[:id]
    User.destroy user

    redirect_to :admin_users, flash: {success: "#{user.name}さんを削除しました。"}
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def reject_destroy_self
    user = User.find params[:id]
    return unless user == current_user

    redirect_to admin_users_path, flash: {error: "#{user.name}さん自身を削除することはできません。"}
  end

  def reject_destroy_when_nonblank_detail
    user = User.find params[:id]
    return if user.order.order_details.empty?

    redirect_to admin_users_path, flash: {error: "#{user.name}さんはお茶を注文しているので、削除できません。"}
  end

  def reject_update_giving_self_name
    user = User.find(params[:id])
    if user_params[:name] == user.name
      redirect_to edit_admin_user_path(user), flash: {error: '変更前と同じ名前です。'}
    end
  end
end
