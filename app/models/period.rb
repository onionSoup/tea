class Period < ActiveRecord::Base
  before_create  :must_be_singleton

  class << self
    def can_destroy?
      return false unless singleton_instance
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
  end

  private

  def must_be_singleton
    #inculude Singletonは副作用が大きいので、これで擬似的に実現
    raise 'Period must be a singleton' if self.class.count.nonzero?
  end
end
