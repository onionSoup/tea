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

    #order_spec.rbに書くと、aliceが消去された時なのかどうかわかりにくいのでここに書く
    it 'alice.orderだけ消去すると、alice.order_detailsが消える。detailsが空のalice.orderが再度できる。' do
      Order.find(alice.order).destroy

      #alice.order.order_detailsだとまだ残っているので。
      expect(User.find(alice).order.order_details).to be_empty
    end
  end
end
