feature '管理者ページからユーザーの注文を変更する' do
  fixtures :items

  let!(:alice) { create(:user, name: 'Alice') }

  background do
    alice.order.update_attributes(
      order_details: [build(:order_detail, item: items(:herb_tea))]
    )
    
    login_as 'Alice'

    visit 'admin/users'
  end

  context '編集ページに来た時' do
    background do
      within ".user#{alice.id}" do
        click_link '編集'
      end
    end

    scenario '削除リンクを押すと、商品を削除できる' do
      click_link '注文変更ページ'

      detail_id = alice.order.order_details.select {|detail| detail.item.name == "herb_tea"}.first.id
      
      within ".detail#{detail_id}" do
        click_link '削除'
      end

      expect(page).not_to exist_in_table "#{items(:herb_tea).name}"
    end

    scenario '注文変更ページに飛んでお茶を追加すると、明細表に表示される。' do
      click_link '注文変更ページ'

      choose_item_and_quantity items(:ice_mint), 1
      click_button '追加する'

      expect(page).to exist_in_table "#{items(:ice_mint).name}"
    end

    context 'ネスレに発注した後の時' do
      background do
        alice.order.update_attributes! state: 'ordered'
        click_link '注文変更ページ'
      end

      scenario '注文の変更はできない' do
        expect(page).to have_content '変更できません。'
        expect(page).not_to have_link '削除'
        expect(page).not_to have_button '追加する'
      end
    end
  end
end
