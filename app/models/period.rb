class Period < ActiveRecord::Base
  before_create  :must_be_singleton

  class << self
    def can_destroy?
      return false unless singleton_instance
      Order.all_empty?
    end

    #読みやすくするためだけに用意したメソッド。不要かも。
    def singleton_instance
      take
    end
  end

  private

  def must_be_singleton
    #inculude Singletonは副作用が大きいので、これで擬似的に実現
    raise 'Period must be a singleton' if self.class.count.nonzero?
  end
end
