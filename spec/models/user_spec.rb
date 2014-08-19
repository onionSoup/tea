describe User do
  fixtures :items
  let!(:alice) { create(:user, name: 'Alice') }

  it 'before_create callbackによりremember_tokenが設定される' do
    expect(alice.remember_token).to be_a_kind_of String
  end

  context 'aliceがherb_teaを注文している時' do
    before do
      alice.order.update_attributes(
        order_details: [
          build(:order_detail, item: items(:herb_tea), quantity: 1)
        ]
      )
    end

    it 'alice自身を消去すると、一緒にalice.orderもalice.order.order_detailsも消える' do
      before_count = [User.count, Order.count, OrderDetail.count]

      alice.destroy

      after_count = [User.count, Order.count, OrderDetail.count]

      expect([before_count, after_count]).to eq [[1,1,1], [0,0,0]]
    end

    it 'alice.orderだけ消去すると、alice.order_detailsが消える。aliceのorderをコールバックでは作らない。' do
      Order.find(alice.order).destroy

      expect(User.find(alice).order).to eq nil
    end
  end
end
