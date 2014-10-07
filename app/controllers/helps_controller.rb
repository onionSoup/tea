class HelpsController < ApplicationController
  include Login
  before_action :need_logged_in, only: [:edit, :update]

  def show
  end
end
