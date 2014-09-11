class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by!(name: params[:sessions][:name])
    #社内用なので、パスワードの認証はしない。
    log_in user
    redirect_to order_path, flash: {success: 'ログインしました。'}
  rescue ActiveRecord::RecordNotFound => e
    flash.now[:error] = 'そのユーザは存在しません。新規ユーザー登録してください'
    render :new
  end

  def destroy
    log_out

    redirect_to root_url, flash: {success: 'ログアウトしました。'}
  end
end
