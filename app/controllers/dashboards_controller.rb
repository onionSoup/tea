class DashboardsController < ApplicationController
  include Login
  before_action :need_logged_in

  def show
    @order = User.includes(:order).find(current_user).order
  end

  private

  def dashboard_params
    params.require(:dashboard).permit()
  end
end
