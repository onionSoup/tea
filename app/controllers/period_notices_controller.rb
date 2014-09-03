class PeriodNoticesController < ApplicationController
  before_action :to_detail_if_defined_times, only: [:show]
  def show
  end

  private

  #最終的には、order_details#indexとorders#showに言って欲しい２通りある。
  #しかし、その振り分けはorder_details_pathでやってくれるので、ここで分岐は不要。
  def to_detail_if_defined_times
    redirect_to order_details_path if Period.has_defined_times?
  end
end
