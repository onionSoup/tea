class Admin::PeriodsController < ApplicationController
  def show
    @period   = Period.singleton_instance
    @end_time = @period.end_time ? @period.end_time.in_time_zone('Tokyo').to_date : Time.zone.now.in_time_zone('Tokyo').days_since(7)
  end

  def edit
    @period = Period.singleton_instance
  end

  def update
    @period = Period.singleton_instance
    begin
      date = Date.new *(period_params.values.map{|str| str.to_i})
    rescue ArgumentError
      #２月３１日とか指定するとここに来る
    end
    @period.update_attributes! end_time: date.in_time_zone('Tokyo')


    redirect_to admin_period_path, flash: {success: "注文期限を#{l(@period.end_time.in_time_zone('Tokyo'))}に変更しました。"}
  rescue ActiveRecord::RecordInvalid => e
    @period  = e.record
    @period  = @period.singleton_instance

    render :edit
  end

  private

  def period_params
    params.require(:date).permit(:year, :month, :day)
  end
end

