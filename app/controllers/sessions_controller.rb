class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by!(name: params[:sessions][:name])
    #社内用なので、パスワードの認証はしない。
    sign_in user
    redirect_to url_for_index_or_show, flash: {success: 'ログインしました。'}
  rescue ActiveRecord::RecordNotFound => e
    flash.now[:error] = 'そのユーザは存在しません。新規ユーザー登録してください'
    render 'new'
  end

  def destroy
    sign_out

    redirect_to root_url, flash: {success: 'ログアウトしました。'}
  end

  private

  def url_for_index_or_show
    if current_user.order.registered?
      order_details_path
    else
      order_path
    end
  end
end
