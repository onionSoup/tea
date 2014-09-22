class UsersController < ApplicationController
  include Login
  before_action :need_logged_in, only: [:edit, :update]
  before_action :reject_update_giving_self_name, only: [:update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create!(user_params)
    log_in @user
    redirect_to order_path, flash: {success: 'ユーザー登録しました。'}
  rescue ActiveRecord::RecordInvalid => e
    @user = e.record
    render :new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update! user_params

    redirect_to edit_user_path(@user), flash: {success: "名前を#{@user.name}さんに変更しました。"}
  rescue ActiveRecord::RecordInvalid => e
    @users           = e.record
    @user_name_in_db = User.find(params[:id]).name

    render :edit
  end


  private

  def user_params
    params.require(:user).permit(:name)
  end

  def reject_update_giving_self_name
    if user_params[:name] == current_user.name
      redirect_to edit_user_path(current_user), flash: {error: '変更前と同じ名前です。'}
    end
  end
end
