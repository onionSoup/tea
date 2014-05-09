class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:sessions][:name])
    #パスワードを持たないので、これにする
    if user
      #ログインさせる
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'そのユーザは存在しません。'
      render 'new'
    end

  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
