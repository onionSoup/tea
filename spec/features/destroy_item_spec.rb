feature '商品の削除' do
  let(:herb_tea) { create(:item, name: 'herb_tea', price: 756) }

  context '既存の商品がある場合' do
    background do
      herb_tea
    end

    scenario '削除リンクを押せば、既存の商品を削除できる' do
      visit '/admin/items'

      expect(page).to have_content 'herb_tea'

      within ".change_item_#{herb_tea.id}" do
        click_link '削除'
      end

      expect(page).not_to have_content 'herb_tea'
    end
  end

  context 'herb_teaを注文しているAliceがログインしている時'do
    background do
      alice = create(:user, name: 'Alice')
      alice.order.order_details << build(:order_detail, item: herb_tea)

      login_as 'Alice'
    end

    let(:alice) { User.find_by!(name: 'Alice') }

    scenario 'herb_teaを含む注文情報がある場合、herb_teaは削除できない' do
      visit '/admin/items'

      within ".change_item_#{herb_tea.id}" do
        click_link '削除'
      end

      expect(page).to have_content 'この商品を使った注文情報があるので、削除できません。'
      expect(page).to have_content 'herb_tea'
    end

    scenario 'herb_teaを含む注文情報を削除すれば、herb_teaを削除できる。' do
      #管理者用ページで注文の状態を更新していき、注文情報を削除する。
      form_visiting_registered_to_delete_exchanged_of alice

      click_link '商品の管理'

      within ".change_item_#{herb_tea.id}" do
        click_link '削除'
      end

      expect(page).not_to have_content 'herb_tea'
    end
  end
end
