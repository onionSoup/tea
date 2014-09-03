# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  remember_token :string(255)
#

FactoryGirl.define do
  factory :user do
    name 'Eve'
  end
end
