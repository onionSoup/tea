class Admin::PeriodsController < ApplicationController
  include Login
  before_action :need_logged_in

  def show
    @period   = Period.singleton_instance
    @end_time = @period.end_time ? @period.end_time.in_time_zone('Tokyo').to_date : Time.zone.now.in_time_zone('Tokyo').days_since(7)
  end

  def update
    @period = Period.singleton_instance
    begin
      begin_time = @period.begin_time || Time.zone.now.in_time_zone('Tokyo').at_beginning_of_day
      end_time   = Date.new(*(period_params.values.map{|str| str.to_i})).in_time_zone('Tokyo').at_end_of_day
    rescue ArgumentError
      #２月３１日とか指定するとここに来る {"year"=>"2015", "month"=>"", "day"=>"5"}も同様。
      #なぜか{"year"=>"", "month"=>"1", "day"=>"5"}はこないのでend_time_is_tomorrow_or_later？で捕まえる。
      redirect_to(admin_period_path, flash: {error: "指定した日付は存在しません。"}) and return
    end

    #tomorrow_or_laterはここ限定でvalidationにできない。そのためbegin rescueではなくif elseで書く。
    if Period.end_time_is_tomorrow_or_later?(end_time) && @period.update_attributes(begin_time: begin_time, end_time: end_time)

      redirect_to admin_period_path, flash: {success: "注文期限を#{l(@period.end_time.in_time_zone('Tokyo'))}に設定しました。"}
    else
      @end_time = @period.end_time ? @period.end_time.in_time_zone('Tokyo').to_date : Time.zone.now.in_time_zone('Tokyo').days_since(7)

      redirect_to admin_period_path, flash: {error: '注文期限が不正です。'}
    end
  end

  def destroy
    User.all.each do |user|
      Order.destroy user.order
      user.create_order
    end

    @period = Period.singleton_instance.destroy!
    redirect_to admin_period_path, flash: {success: '注文期間と注文情報を削除しました。'}
  end

  def expire
    Period.set_out_of_date_times!
    redirect_to admin_period_path, flash: {success: '注文期間を終了させました。'}
  rescue
    redirect_to admin_period_path, flash: {error: '注文期間を終了できませんでした。'}
  end

  private

  def period_params
    params.require(:date).permit(:year, :month, :day)
  end
end
