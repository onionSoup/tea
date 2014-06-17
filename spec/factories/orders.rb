#このファクトリが存在する理由はまだ殆どない。
#しかし今後、quantity 1 のようなデフォルト値が増えていった場合、このファクトリの存在意義が出てくると思う。
#order = build(:order, user_id: user.id, state: Order.states[state]) do |order|
  #order.order_details.build(attributes_for(:order_detail, item_id: ice_mint.id, quantity: 1))
  #order.order_details.build(attributes_for(:order_detail, item_id: red_tea.id, quantity: 9))
#end

FactoryGirl.define do
  factory :order_detail do
    quantity  1
    #これは書けない。check_order_details_numberのvalidationがあるorderは、先にorder_detailができてないと作れないため。
    #order

    after :build do |detail|
      build :order, order_details: [detail]
    end
  end

  factory :order do
    user
    #このファクトリの定義が完了する前にorder_detailをつくって、このOrderのidをいれることができれば、lintに通るファクトリができる。
  end
end
