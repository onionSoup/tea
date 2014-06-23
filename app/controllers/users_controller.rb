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
      @user.create_order
      sign_in @user
      flash[:success] = "ユーザー登録しました。"
      redirect_to new_order_path
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
