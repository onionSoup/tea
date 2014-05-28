# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  price      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Item < ActiveRecord::Base
  has_many :order_details

  def self.item_count
    (0..19).map! {|i| ["#{i}個", i] }
  end
end
