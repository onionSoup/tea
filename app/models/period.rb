# == Schema Information
#
# Table name: periods
#
#  id         :integer          not null, primary key
#  begin_time :datetime
#  end_time   :datetime
#  state      :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

class Period < ActiveRecord::Base
  before_create  :must_be_singleton
  after_destroy  :create_another_period

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
      return false if has_undefined_times?
      Time.zone.now.in_time_zone('Tokyo').between?(take.begin_time, take.end_time)
    end

    def out_of_date?
      return false if has_undefined_times?
      !include_now?
    end

    def has_defined_times?
      take.begin_time && take.end_time
    end

    def has_undefined_times?
      !has_defined_times?
    end
  end

  #def can_have_nil_term_only_when_all_order_is_registered
    #return true if Period.take.begin_time
    #return true if Period.take.end

    #Order.all.all? {|order| order.state.not_registered? }
  #end

  private

  def must_be_singleton
    #inculude Singletonは副作用が大きいので、これで擬似的に実現
    raise 'Period must be a singleton' if self.class.count.nonzero?
  end

  def create_another_period
    self.class.create!(
      begin_time: Time.zone.yesterday.in_time_zone('Tokyo'),
      end_time:   Time.zone.now.in_time_zone('Tokyo'),
    )
  end
end
