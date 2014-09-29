feature 'ネスレ入力用ページ' do
  context '注文があるとき' do
    before do
      alice = create(:user, name: 'Alice')

      herb_tea = create(:item, name: 'herb_tea', price: 100)
      red_tea = create(:item, name: 'red_tea', price: 100)

      alice.order.update_attributes(
        order_details: [
          build(:order_detail, item: herb_tea, quantity: 1),
          build(:order_detail, item: red_tea, quantity: 9)
        ]
      )
      login_as 'Alice'
      visit '/orders/registered'
    end

    scenario '商品名と注文合計金額が表示されている' do
      expect(page).to have_content 'herb_tea'
      expect(page).to have_content '1000円' #これのためfixtureを使わない
    end

    scenario 'ユーザーごとの詳細が見れる' do
      table_of_order_by_user = page.find('.admin_order_table.users_table_in_admin_orders_pages')

      expect(table_of_order_by_user).to have_content 'Alice'
      expect(table_of_order_by_user).to have_content 'herb_tea'
      expect(table_of_order_by_user).to have_content '1000'
    end

    scenario 'ユーザーへの通知用フィールドに@付きのユーザー名と合計金額が表示されている' do
      within '#fe_text' do
        expect(page).to have_content '@Alice'
        expect(page).to have_content '1000'
      end
    end

    context '注文期間中のとき' do
      background do
        raise 'Period must include_now' unless Period.include_now?
      end
      scenario '注文完了登録ボタンが押せない' do
        expect(page).to have_css '[type=submit][disabled=disabled]'
      end
    end

    context '注文期間外のとき' do
      include_context '注文期間がすぎるまで待つ'
      background do
        visit '/orders/registered'
      end

      scenario '注文完了登録ボタンを押すと、ネスレ発送待ちページに移動して成功メッセージがでる' do
        click_button '発注の完了をシステムに登録'

        expect(page.current_path).to eq '/orders/ordered'
        expect(page).to have_content 'ネスレ公式へ注文したことを登録しました。'
        expect(page).to have_content 'herb_tea'
      end
    end
  end

  context '何も注文されてない時' do
    background do
      create_user_and_login_as 'Alice'

      visit '/orders/registered'
    end

    scenario 'ボタンを押すことができない' do
      expect(page).not_to  have_button '発注の完了をシステムに登録'
      expect(page).to      have_css '[type=submit][disabled=disabled]'

      disabled_text = find('[type=submit][disabled=disabled]').value
      expect(disabled_text).to eq '発注の完了をシステムに登録'
    end

    scenario '該当するお茶がないことがわかる' do
      within '.all_user_sum_table' do
        expect(page).to have_content '該当するお茶がありません'
      end
    end

    scenario '該当するユーザーがいないことがわかる' do
      within '.users_table_in_admin_orders_pages' do
        expect(page).to have_content '該当するユーザーがいません'
      end
    end
    scenario '通知用フィールドから該当するユーザーがいないことがわかる' do
      within '#fe_text' do
        expect(page).to have_content '該当するユーザーがいません'
      end
    end
  end
end
