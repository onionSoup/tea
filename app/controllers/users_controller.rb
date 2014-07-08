class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to edit_order_path, flash: {success: 'ユーザー登録しました。'}
    else
      @invalid_error_message =  @user.errors.messages[:name].join
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
