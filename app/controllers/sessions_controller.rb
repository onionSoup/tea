class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:sessions][:name])
    #パスワードが必要になったらここに書く。
    if user
      #ログインさせる
      sign_in user
      flash[:success] = 'ログインしました。'
      redirect_to create_or_edit_order_path_of(user)
    else
      flash.now[:error] = 'そのユーザは存在しません。新規ユーザー登録してください'
      render 'new'
    end
  end

  def destroy
    sign_out
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
end
