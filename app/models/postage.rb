# == Schema Information
#
# Table name: postages
#
#  id         :integer          not null, primary key
#  border     :integer
#  cost       :integer
#  created_at :datetime
#  updated_at :datetime
#

class Postage < ActiveRecord::Base
  include PseudoSingleton
  before_create :must_be_singleton

  validates :border, presence:     true,
                     numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :cost,   presence:     true,
                     numericality: {only_integer: true, greater_than_or_equal_to: 0}
end
