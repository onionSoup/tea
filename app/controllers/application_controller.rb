class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper

  #def redirect_to_details_or_show
   # if conditions_to_get_index
    #  redirect_to order_details_path
    #else
     # redirect_to order_show_path
    #end
  #end
end
