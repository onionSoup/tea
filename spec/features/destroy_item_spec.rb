feature '商品の削除' do
  scenario '削除リンクを押せば、既存の商品を削除できる' do
    item = create(:item, name: 'herb_tea', price: 756)

    visit '/admin/items'

    expect(page).to have_content 'herb_tea'

    within ".change_item_#{item.id}" do
      click_link '削除'
    end

    expect(page).not_to have_content 'herb_tea'
  end

  scenario '商品Aを含む注文情報がある場合、商品Aは削除できない' do
    herb_tea = create(:item, name: 'herb_tea')
    create :order, :buyer, order_details: [build(:order_detail, item: herb_tea)]

    visit '/admin/items'

    item = Item.find_by_name('herb_tea')

    within ".change_item_#{item.id}" do
      click_link '削除'
    end

    expect(page).to have_content 'この商品を使った注文情報があるので、削除できません。'
    expect(page).to have_content 'herb_tea'
  end

  scenario '商品Aを含む注文情報を削除すれば、商品Aを削除できる。' do
    alice = create(:user, name: 'Alice')
    herb_tea = create(:item, name: 'herb_tea')
    alice.order.order_details << build(:order_detail, item: herb_tea)

    login_as 'Alice'

    #管理者用ページで注文の状態を更新していき、注文情報を削除する。
    form_visiting_registered_to_delete_exchanged_of(alice)

    #商品管理ページで、herb_teaを削除する。
    click_link '商品の管理'
    within ".change_item_#{herb_tea.id}" do
      click_link '削除'
    end

    expect(page).not_to have_content 'herb_tea'
  end
end
