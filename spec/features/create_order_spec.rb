feature '注文作成', :js do
  background do
    create :item, name: 'アイスミント'
    create :item, name: '紅茶'
    create_user_and_login_as 'Bob'
  end

  scenario '品名と量を選ぶと、合計金額が見れる' do
    choose_item_and_quantity 'アイスミント', 2
    click_button '注文する'
    choose_item_and_quantity '紅茶', 8
    click_button '注文する'

    expect(page).to have_content '7560円'
  end

  scenario '品名と量を指定して注文すると注文ができて、明細票にのる' do
    choose_item_and_quantity 'アイスミント', 2
    click_button '注文する'

    expect(exist_tea_in_table? 'アイスミント').to be true
  end
end
