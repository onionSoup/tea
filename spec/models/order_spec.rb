describe Order do
  fixtures :items
  let(:herb_tea) { Item.find_by_name! 'herb_tea' }

  it 'is valid with user and order_details' do
    order = build(:order, :buyer) {|order|
      order.order_details.build attributes_for(:order_detail, item: herb_tea)
    }

    expect(order).to be_valid
  end

  it 'is valid without order_details' do
    order = build(:order, :buyer)

    expect(order).to be_valid
  end

  context 'when there is same item' do
    it 'is invalid with order_details of same item' do
      order = build(:order,
        order_details: [
          build(:order_detail, item: herb_tea),
          build(:order_detail, item: herb_tea)
        ]
      )

      expect(order).to be_invalid
      expect(order.errors.messages[:base].join).to match /その商品は既に注文しています/
    end

    it 'is valid with two orders of same item' do
      alice = create(:user, name: 'Alice')
      bob = create(:user, name: 'Bob')

      alice.order = build(:order, order_details: [build(:order_detail, item: herb_tea)])
      bob.order = build(:order, order_details: [build(:order_detail, item: herb_tea)])

      expect(alice.order).to be_valid
      expect(bob.order).to be_valid
    end
  end

  context 'when destroy' do
    it 'should create new order after destroy order' do
      alice = create(:user, name: 'Alice')
      alice.order.order_details << build(:order_detail, item: herb_tea)

      Order.find(alice.order).destroy

      order_of_alice = User.find(alice).order

      expect(order_of_alice.order_details).to eq([])
    end
  end
end
