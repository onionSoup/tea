shared_context 'herb_teaを注文しているAliceとしてログイン' do
  let!(:alice) { create(:user, name: 'Alice') }

  background do
    alice.order.order_details << build(:order_detail, item: items(:herb_tea))

    login_as 'Alice'
  end
end

shared_context '注文期間がすぎるまで待つ' do
  background do
    wait_untill_period_become_out_of_date
  end
end
