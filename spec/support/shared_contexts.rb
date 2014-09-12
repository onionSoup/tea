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


shared_context 'ネスレ入力用ページに行って、注文を発注する' do
  background do
    visit '/orders/registered'
    click_button '注文の完了をシステムに登録'
  end
end

shared_context '発送待ち商品確認ページに行って、お茶を受領する' do
  background do
    visit '/orders/ordered'
    click_button 'お茶の受領をシステムに登録'
  end
end

shared_context '引換用ページに行って、userの注文を引換する' do |user_name: 'user_name'|
  background do
    visit '/orders/arrived'
    user = User.find_by!(name: user_name)

    check "user_#{user.id}"
    click_button '引換の完了をシステムに登録'
  end
end
