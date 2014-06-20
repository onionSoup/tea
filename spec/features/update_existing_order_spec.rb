feature '既存の注文を修正する'do
  background do
    create_order 'registered'

    visit '/sessions/new'
    fill_in 'ユーザー名', :with => 'Alice'
    click_button 'ログイン'
  end

  scenario '注文情報がある場合、新規注文はできない' do
    pending('未実装')

    visit 'order/new'
    choose_item_quantity_at_nth_selector 'アイスミント', 2, 0
    click_button '注文を確定する'
    expect(page).not_to have_content 'ご注文の確認'
  end

  scenario 'まだネスレ入力用シートで入力してなければ注文の修正ができる' do
    pending('未実装')
    visit 'order/edit'
    choose_item_quantity_at_nth_selector 'アイスミント', 2, 0
    click_button '注文を確定する'
    expect(page).to have_content 'ご注文の確認'
  end

  scenario 'ネスレ入力用シートで入力した場合、注文の修正はできない' do
    pending('未実装')

    visit 'orders/registered'
    click_button '注文の完了をシステムに登録'

    visit 'order/edit'
    choose_item_quantity_at_nth_selector 'アイスミント', 2, 0
    click_button '注文を確定する'
    expect(page).not_to have_content 'ご注文の確認'
  end

  scenario '注文情報を削除した後、再度注文を作れる。' do
    pending('未実装')

    #管理者用ページで注文の状態を更新していき、注文情報を削除する。DRYにしたいが名前が思いつかない。
    click_link '管理者用'
    click_button '注文の完了をシステムに登録'
    click_button 'お茶の受領をシステムに登録'
    check 'checkbox_no_0'
    click_button '引換の完了をシステムに登録'
    click_button 'このページの引換情報を削除'

    visit 'order/new'
    choose_item_quantity_at_nth_selector 'アイスミント', 2, 0
    click_button '注文を確定する'
    expect(page).to have_content 'ご注文の確認'
  end
end
