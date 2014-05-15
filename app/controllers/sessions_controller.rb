class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:sessions][:name])
    #パスワードを持たないので、これにする
    if user
      #ログインさせる
      sign_in user
      flash[:success] = 'ログインしました。'
      redirect_to new_order_path
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
