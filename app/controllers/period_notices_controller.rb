class PeriodNoticesController < ApplicationController
  before_action :to_detail_if_enabled, only: [:show]
  def show
  end

  private

  #最終的には、order_details#indexとorders#showに言って欲しい２通りある。
  #しかし、その振り分けはorder_details_pathでやってくれるので、ここで分岐は不要。
  def to_detail_if_enabled
    redirect_to order_details_path if Period.enabled?
  end
end
