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

FactoryGirl.define do
  factory :item do
    name  'レモンティー'
    price 756
  end
end
