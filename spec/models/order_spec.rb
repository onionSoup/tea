describe Order do
  it 'is valid with user and order_details' do
    order = build(:order, user_id: 1) {|order|
      order.order_details.build attributes_for(:order_detail, item_id: 1)
    }

    expect(order).to be_valid
  end

  it 'is invalid without order_details' do
    order = build(:order)
    expect(order).to be_invalid
  end

  it 'is invalid with order_details of same item' do
    item = create(:item)
    order = build(:order,
      order_details: [
        build(:order_detail, item: item),
        build(:order_detail, item: item)
      ]
    )
    expect(order) .to be_invalid
    expect(order.errors.messages[:base].join).to match /order_details_must_have_unique_item_within_same_order/
  end
end
