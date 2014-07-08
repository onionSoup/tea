feature '商品の管理' do
  background do
    create :item, name: 'herb_tea', price: 756

    visit '/orders/registered'

    click_link '商品の管理'
  end

  scenario '編集リンクを押せば、既存の商品の名前と価格の変更ができる' do
    tea_id = Item.find_by_name('herb_tea').id

    within ".change_item_#{tea_id}" do
      click_link '編集'
    end

    fill_in '商品名', with: 'red_tea'
    fill_in '価格', with: '125'

    click_button '保存する'

    expect(page).to have_content 'red_tea'
    expect(page).to have_content '125'
  end

  scenario '新商品登録リンクを押せば、NameとPriceを入力して商品を作れる' do
    click_link '新商品登録ページ'

    fill_in '商品名', with: 'red_tea'
    fill_in '価格', with: '1255'

    click_button '保存する'

    expect(page).to have_content 'red_tea'
    expect(page).to have_content '1255'
  end
end
