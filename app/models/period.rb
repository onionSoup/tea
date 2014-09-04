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
  after_save    :can_has_undefined_times_only_when_all_order_is_registered

  validate :can_has_undefined_times_only_when_all_order_is_registered
  validate :can_be_include_now_only_when_all_order_is_registered


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
      return false if has_undefined_times?
      !include_now?
    end

    def has_defined_times?
      take.has_defined_times?
    end

    def has_undefined_times?
      !has_defined_times?
    end

    def set_out_of_date_times
      take.update_attributes!(
        begin_time: Time.zone.now.years_ago(2000).in_time_zone('Tokyo'),
        end_time:   Time.zone.now.years_ago(1000).in_time_zone('Tokyo')
      )
    end

    def set_undefined_times
      take.update_attributes!(
        begin_time: nil,
        end_time:   nil
      )
    end
  end

  def include_now?
    return false if has_undefined_times?
    Time.zone.now.in_time_zone('Tokyo').between?(begin_time, end_time)
  end

  def has_defined_times?
    begin_time && end_time
  end

  def has_undefined_times?
    !has_defined_times?
  end

  def can_has_undefined_times_only_when_all_order_is_registered
    return if has_undefined_times?
    return if Order.all.empty?

    if Order.all.any? {|order| order.not_registered? }
      errors[:base] << 'must have defined_times when there are not_registered orders'
    end
  end

  def can_be_include_now_only_when_all_order_is_registered
    return unless include_now?
    return if     Order.all.empty?

    if Order.all.any? {|order| order.not_registered? }
      errors[:base] << 'must have defined_times when there are not_registered orders'
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
