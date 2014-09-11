shared_context 'herb_teaを注文しているAliceとしてログイン' do
  include_context 'Aliceが登録してherb_teaを注文している'
  background do
    login_as 'Alice'
  end
end

shared_context '注文期間がすぎるまで待つ' do
  background do
    wait_untill_period_become_out_of_date
  end
end

shared_context 'Aliceが登録してherb_teaを注文している' do
  let!(:alice) { create(:user, name: 'Alice') }

  background do
    alice.order.update_attributes! order_details: [build(:order_detail, item: items(:herb_tea))]
  end
end

#TODO 後で変数使えないか調べる
shared_context 'Bobが登録してherb_teaを注文している' do
  let!(:bob) { create(:user, name: 'Bob') }

  background do
    bob.order.update_attributes! order_details: [build(:order_detail, item: items(:herb_tea))]
  end
end

