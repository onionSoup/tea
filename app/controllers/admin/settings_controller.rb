class Admin::SettingsController < ApplicationController
  include Login
  before_action :need_logged_in

  def show
  end

  def update
    before_save_user = current_user

    current_user.update_attributes! setting_params

    redirect_to admin_setting_path, flash: {success: "#{current_user.name}さんの管理者設定を指定しました。"}
  end

  private

  def setting_params
    params.require(:setting).permit(:admin)
  end
end
