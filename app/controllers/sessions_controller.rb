class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:sessions][:name])
    #パスワードが必要になったらここに書く。
    if user
      #ログインさせる
      sign_in user
      redirect_to edit_order_path, flash: {success: 'ログインしました。'}
    else
      flash.now[:error] = 'そのユーザは存在しません。新規ユーザー登録してください'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url, flash: {success: 'ログアウトしました。'}
  end
end
