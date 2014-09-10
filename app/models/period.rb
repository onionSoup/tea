# == Schema Information
#
# Table name: periods
#
#  id         :integer          not null, primary key
#  begin_time :datetime
#  end_time   :datetime
#  created_at :datetime
#  updated_at :datetime
#

class Period < ActiveRecord::Base
  before_create :must_be_singleton
  after_destroy :create_another_period

  validate :begin_time_must_be_before_now
  validate :can_has_undefined_times_only_when_all_order_are_registered
  validate :can_has_undefined_times_only_when_all_order_have_not_detail
  validate :can_be_include_now_only_when_all_order_are_registered

  class << self
    def can_destroy?
      Order.all_empty?
    end

    #このクラスの外で、Period.take.destroyと書くとびっくりされそうなので用意。
    #takeだけで読み手が文脈汲み取ってくれるなら不要。
    def singleton_instance
      take
    end

    def include_now?
      take.include_now?
    end

    def out_of_date?
      take.out_of_date?
    end

    def has_defined_times?
      take.has_defined_times?
    end

    def has_undefined_times?
      !has_defined_times?
    end

    def set_one_week_term_include_now!
      take.set_one_week_term_include_now!
    end


    def set_out_of_date_times!
      take.update_attributes!(
        begin_time: Time.zone.now.years_ago(30).in_time_zone('Tokyo'),
        end_time:   Time.zone.now.years_ago(20).in_time_zone('Tokyo')
      )
    end

    def set_undefined_times!
      take.update_attributes!(
        begin_time: nil,
        end_time:   nil
      )
    end

    #validationにはできない。時間が経過すればend_timeは現在以前の値を当然取る。
    #UIから、現在を含む注文期間を生成するときだけ、このメソッドの縛りをかける。
    def end_time_is_tomorrow_or_later?(end_time)
      end_time > Time.zone.now.in_time_zone('UTC').tomorrow.at_beginning_of_day
    end

    def state
      return :include_now         if include_now?
      return :out_of_date         if out_of_date?
      return :has_undefined_times if has_undefined_times?
    end
  end

  def set_one_week_term_include_now!
    update_attributes!(
            begin_time: Time.zone.now.in_time_zone('Tokyo').at_beginning_of_day,
            end_time:   Time.zone.now.in_time_zone('Tokyo').days_since(7).at_end_of_day
    )
  end

  def include_now?
    return false if has_undefined_times?
    Time.zone.now.in_time_zone('Tokyo').between?(begin_time, end_time)
  end

  def out_of_date?
    return false if has_undefined_times?
    !include_now?
  end

  def has_defined_times?
    begin_time && end_time
  end

  def has_undefined_times?
    !has_defined_times?
  end

  def begin_time_must_be_before_now
    !begin_time.try(:future?)
  end

  def can_has_undefined_times_only_when_all_order_are_registered
    return if has_defined_times?

    if Order.all.any? {|order| order.not_registered? }
      errors[:base] << 'must have defined_times when there are not_registered orders'
    end
  end

  def can_has_undefined_times_only_when_all_order_have_not_detail
    return if has_defined_times?

    if Order.all.any? {|order| order.order_details.present? }
      errors[:base] << 'must have defined_times when there are not order_details'
    end
  end

  def can_be_include_now_only_when_all_order_are_registered
    return unless include_now?

    if Order.all.any? {|order| order.not_registered? }
      errors[:base] << 'must have out_of_date_times when there are not_registered orders'
    end
  end

  private

  def must_be_singleton
    #inculude Singletonは副作用が大きいので、これで擬似的に実現
    raise 'Period must be a singleton' if self.class.count.nonzero?
  end

  def create_another_period
    self.class.create! begin_time: nil, end_time: nil
  end
end
