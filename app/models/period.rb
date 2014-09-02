class Period < ActiveRecord::Base
  before_create  :must_be_singleton
  after_destroy  :create_another_period

  enum state: %i(disabled enabled)

  class << self
    def can_destroy?
      return false if take.disabled?
      Order.all_empty?
    end

    #このクラスの外で、Period.take.destroyと書くとびっくりされそうなので用意。
    #takeだけで読み手が文脈汲み取ってくれるなら不要。
    def singleton_instance
      take
    end

    def include_now?
      present_time.between?(take.begin_time, take.end_time)
    end

    #これはこのモデルの外でもいいかも。
    def present_time
      Time.zone.now.in_time_zone('Tokyo')
    end

    def deadline
      take.end_time
    end

    def enabled?
      take.state == 'enabled'
    end

    def disabled?
      take.state == 'disabled'
    end
  end

  private

  def must_be_singleton
    #inculude Singletonは副作用が大きいので、これで擬似的に実現
    raise 'Period must be a singleton' if self.class.count.nonzero?
  end

  def create_another_period
    self.class.create!(
      begin_time: Time.zone.yesterday.in_time_zone('Tokyo'),
      end_time:   Time.zone.now.in_time_zone('Tokyo'),
      state:     'disabled'
    )
  end
end
