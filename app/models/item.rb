# == Schema Information
#
# Table name: items
#
#  id                        :integer          not null, primary key
#  name                      :string(255)
#  price                     :integer
#  created_at                :datetime
#  updated_at                :datetime
#  nestle_index_from_the_top :integer
#

class Item < ActiveRecord::Base
  has_many  :order_details

  validates :name,  presence:     true,
                    uniqueness:   true,
                    length:       {maximum: 25}
  validates :price, presence:     true,
                    numericality: {only_integer: true, greater_than_or_equal_to: 0}

  def can_destroy?
    Period.out_of_date?.!
  end
end
