feature '商品の管理' do
  background do
    create :item, name: '玄米茶', price: 756
    visit '/orders/registered'
    click_link '商品の管理'
  end

  scenario '編集リンクを押せば、既存の商品の名前と価格の変更ができる' do
    #linkはidかtextで探す。textはどれも同じなので、idで探すしかない。
    click_link 'edit_0th_item'

    fill_in 'Name', with: '爽健美茶'
    fill_in 'Price', with: '125'
    click_button 'Update Item'

    expect(page).to have_content '爽健美茶'
    expect(page).to have_content '125'
  end

  scenario '新商品登録リンクを押せば、NameとPriceを入力して商品を作れる' do
    click_link '新しい商品を登録する'

    fill_in 'Name', with: 'ダージリン'
    fill_in 'Price', with: '1255'
    click_button 'Create Item'

    expect(page).to have_content 'ダージリン'
    expect(page).to have_content '1255'
  end
end
