feature '商品の削除' do
  fixtures :items
  background do
    create_user_and_login_as 'Bob'
  end

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

      within '#flash_error_p' do
        expect(page).to have_content '削除できません。'
      end
      expect(page).to have_content 'herb_tea'
    end

    context '注文期間を削除した場合' do
      background do
        #管理者用ページで注文の状態を更新していき、引換までする。
        form_visiting_registered_to_exchanged_of alice

        visit '/admin/period'
        click_button '注文期間を削除する'
      end
      scenario 'herb_teaを削除できる。' do
        click_link '商品の編集・削除'

        within ".#{ActionView::RecordIdentifier.dom_id(items(:herb_tea), :change)}" do
          click_link '削除'
        end

        expect(page).to have_content 'herb_teaを削除しました。'
      end
      context '注文期間を削除後、注文期間を再設定した場合' do
        background do
          choose_date(days_since: 1)
          click_button '注文期限の設定'
        end
        scenario 'herb_teaを削除できる。' do
          click_link '商品の編集・削除'

          within ".#{ActionView::RecordIdentifier.dom_id(items(:herb_tea), :change)}" do
            click_link '削除'
          end

          expect(page).to have_content 'herb_teaを削除しました。'
        end
      end
    end
  end
end
