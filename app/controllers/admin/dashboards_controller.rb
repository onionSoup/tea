class Admin::DashboardsController < ApplicationController
  include Login
  before_action :need_logged_in

  def show
  end
end
