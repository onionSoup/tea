module PseudoSingleton
  def must_be_singleton
    #inculude Singletonは副作用が大きいので、これで擬似的に実現
    raise "#{self.class} must be a singleton" if self.class.count.nonzero?
  end
end
