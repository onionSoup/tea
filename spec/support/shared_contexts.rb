shared_context 'herb_teaを注文しているAliceとしてログイン' do
  let!(:alice) { create(:user, name: 'Alice') }

  background do
    alice.order.order_details << build(:order_detail, item: items(:herb_tea))

    login_as 'Alice'
  end
end
