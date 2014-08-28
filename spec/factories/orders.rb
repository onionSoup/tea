# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  state      :integer          default(0)
#

FactoryGirl.define do
  factory :order_detail do
    quantity  1
  end

  factory :order do
    trait :buyer do
      user
    end
  end
end
