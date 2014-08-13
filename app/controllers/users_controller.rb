class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create!(user_params)
    sign_in @user
    redirect_to order_details_path, flash: {success: 'ユーザー登録しました。'}
  rescue ActiveRecord::RecordInvalid => e
    @user = e.record
    @invalid_error_message =  @user.errors.messages[:name].join
    render 'new'
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
