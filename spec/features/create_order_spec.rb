feature '注文作成', :js do
  background do
    create :item, name: 'アイスミント'
    create :item, name: '紅茶'
    create_user_and_login_as 'Bob'
  end

  scenario '何も選択せずに注文ボタンを押すと、同じ画面に' do
    click_button '注文する'

    expect(page).to have_content '注文する'
  end

  scenario '同じ商品を複数回選択すると、注文されず同じ画面に' do
    choose_item_and_quantity 'アイスミント', 2
    choose_item_and_quantity 'アイスミント', 1
    click_button '注文する'

    expect(page).to have_content '注文する'
  end


  scenario '品名と量を選ぶと、合計金額が見れる' do
    pending 'ui変更に伴い、jacvascriptを書き換えなければならないため'
    choose_item_and_quantity 'アイスミント', 2
    choose_item_and_quantity '紅茶', 8

    expect(page).to have_content '合計: 7560円'
  end

  scenario '品名と量を指定して注文すると注文ができて、明細票にのる' do
    choose_item_and_quantity 'アイスミント', 2
    click_button '注文する'

    expect(exist_tea_in_table? 'アイスミント').to be true
  end

  scenario '品名と量のいずれかが空白の注文明細だけの場合、注文はされない' do
    choose_item_and_quantity 'アイスミント',''
    choose_item_and_quantity '', 8
    click_button '注文する'

    expect(exist_tea_in_table? 'アイスミント').to be false
  end

  scenario '空白の注文明細と、品名価格ともに指定された注文明細が混じった場合、後者のみ注文される。' do
    choose_item_and_quantity 'アイスミント', ''
    choose_item_and_quantity '紅茶', 10
    click_button '注文する'

    expect(exist_tea_in_table? 'アイスミント').to be false
    expect(exist_tea_in_table? '紅茶').to be true
  end
end
