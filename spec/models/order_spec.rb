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

  #自作validationではなく、組み込みのvalidationを使えるようになった
  #そのためこれは不要かもしれない
  context 'when there is same item' do
    it 'is invalid with order_details of same item' do
      alice = create(:user, name: 'Alice')
      begin
        alice.order.update_attributes(
          order_details: [
            build(:order_detail, item: herb_tea),
            build(:order_detail, item: herb_tea)
          ]
        )
      rescue ActiveRecord::RecordNotSaved
        expect(alice.order.order_details).to be_empty
      end
    end

    it 'is valid with two orders of same item' do
      alice = create(:user, name: 'Alice')
      bob = create(:user, name: 'Bob')

      alice.order.update_attributes(order_details: [build(:order_detail, item: herb_tea)])
      bob.order.update_attributes(order_details: [build(:order_detail, item: herb_tea)])

      expect(alice.order).to be_valid
      expect(bob.order).to be_valid
    end
  end
end
