feature 'ネスレ公式に発注した後の注文修正'do
  background do
    alice = create(:user, name: 'Alice')
    item = create(:item, name: 'herb_tea')
    alice.order.order_details << OrderDetail.new(item: item, quantity: 1)
    login_as 'Alice'
  end

  scenario 'ネスレ入力用シートでボタンを押した後、注文の修正はできない' do
    visit '/orders/registered'
    click_button '注文の完了をシステムに登録'

    visit '/order/edit'
    expect(page).to have_content '注文の修正はできません。'
  end

   scenario 'Aliceの注文をネスレに発注した後でも、Alice以外の人の注文修正はできる。' do
    #Bobでログインし直す
    click_link 'ログアウト'
    create_user_and_login_as 'Bob'

    #ネスレ入力用シートでボタンを押す。Aliceの注文はネスレ公式に発注したことになる。
    visit '/orders/registered'
    click_button '注文の完了をシステムに登録'

    #Bobは注文できる。ハーブティーを２個注文できるのを確認
    visit '/order/edit'
    expect(page).not_to have_content '注文の修正はできません。'
    choose_item_and_quantity 'herb_tea', 2
    click_button '注文する'
    click_link '管理者用'

    expect(page).to have_content 'herb_tea'

    #Aliceの注文は発注されたので修正できない
    click_link 'ログアウト'
    login_as 'Alice'
    visit '/order/edit'
    expect(page).to have_content '注文の修正はできません。'
  end


  scenario '注文情報を削除した後、再度注文を作れる。' do
    #管理者用ページで注文の状態を更新していき、注文情報を削除する。DRYにしたいが名前が思いつかない。
    user = User.first
    click_link '管理者用'
    click_button '注文の完了をシステムに登録'
    click_button 'お茶の受領をシステムに登録'
    check "user_#{user.id}"
    click_button '引換の完了をシステムに登録'
    click_button 'このページの引換情報を削除'

    #注文情報削除後は、注文画面にいけることを確認する
    click_link '注文画面'
    expect(page).not_to have_content '注文の修正はできません。'

    #注文情報削除後は、注文できることを確認する。
    choose_item_and_quantity 'herb_tea', 2
    click_button '注文する'
    expect(page).to have_content 'herb_tea'
  end
end
