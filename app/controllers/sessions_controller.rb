class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:sessions][:name])
    #社内用なので、パスワードの認証はしない。
    if user
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
