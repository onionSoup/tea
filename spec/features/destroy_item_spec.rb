feature '商品の削除' do
  fixtures :items

  context '既存の商品がある場合' do
    scenario '削除リンクを押せば、既存の商品を削除できる' do
      visit '/admin/items'

      expect(page).to have_content 'herb_tea'

      within ".#{ActionView::RecordIdentifier.dom_id(items(:herb_tea), :change)}" do
        click_link '削除'
      end

      expect(page).to have_content 'herb_teaを削除しました。'
    end
  end

  context 'herb_teaを注文しているAliceがログインしている時'do

    include_context 'herb_teaを注文しているAliceとしてログイン'
    include_context '注文期間がすぎるまで待つ'

    scenario '注文期間外である場合、herb_teaは削除できない' do
      visit '/admin/items'

      within ".#{ActionView::RecordIdentifier.dom_id(items(:herb_tea), :change)}" do
        click_link '削除'
      end

      expect(page).to have_content '注文期間中以外なので、削除できません。'
      expect(page).to have_content 'herb_tea'
    end

    scenario '注文期間を再設定した後なら、herb_teaを削除できる。' do
      #管理者用ページで注文の状態を更新していき、引換までする。
      form_visiting_registered_to_exchanged_of alice

      visit '/admin/period'
      click_button '注文期間を削除する'
      choose_date(days_since: 1)
      click_button '注文期限の設定'

      click_link '商品の管理'

      within ".#{ActionView::RecordIdentifier.dom_id(items(:herb_tea), :change)}" do
        click_link '削除'
      end

      expect(page).to have_content 'herb_teaを削除しました。'
    end
  end
end
