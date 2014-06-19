FactoryGirl.define do
  factory :item do
    name  'レモンティー'
    price 756
  end

  factory :index_name_tea, class: Item do
    sequence(:name) {|n| "tea_no_#{n}" }
    price  756
  end
end
