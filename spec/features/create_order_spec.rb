feature '注文作成', :js do
  background do
    create(:item, name: 'アイスミント')
    create(:item, name: '紅茶')

    #ログインする。
    create(:user, name: 'Bob')
    visit '/sessions/new'
    fill_in 'ユーザー名', :with => 'Bob'
    click_button 'ログイン'
  end

  #selecter_indexは上から何個目（０スタート）を数える
  #もっと良い名前があるはず
  def choose_item_quantity_at_nth_selector(item, quantity,selecter_index)
    select item, :from => "order_order_details_attributes_#{selecter_index}_item_id"
    #こっちは日本語をつけないと動かない
    select "#{quantity}個", :from => "order_order_details_attributes_#{selecter_index}_quantity"
  end

  scenario '何も選択せずに注文ボタンを押すと、同じ画面に' do
    click_button '注文を確定する'

    expect(page).to have_content('注文を確定する')
  end

  scenario '品名と量を選ぶと、合計金額が見れる' do
    choose_item_quantity_at_nth_selector('アイスミント', 2, 0)
    choose_item_quantity_at_nth_selector('紅茶', 8, 1)

    expect(page).to have_content('合計: 7560円')
  end

  scenario '品名と量を指定して注文すると注文ができて、注文確認画面にいく' do
    choose_item_quantity_at_nth_selector('アイスミント', 2, 0)
    click_button '注文を確定する'

    expect(page).to have_content('ご注文の確認')
  end
end
