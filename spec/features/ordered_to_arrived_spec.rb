feature '発送待ち商品の確認' do
  context 'ネスレの発送を待っているお茶があるとき' do
    before do
      alice = create(:user, name: 'Alice')

      herb_tea = create(:item, name: 'herb_tea', price: 100)
      red_tea = create(:item, name: 'red_tea', price: 100)

      wait_untill_period_become_out_of_date

      alice.order.update_attributes!(
        state: 'ordered',
        order_details: [
          build(:order_detail, item: herb_tea, quantity: 1),
          build(:order_detail, item: red_tea,  quantity: 9)
        ]
      )

      login_as 'Alice'
    end

    scenario 'ページにアクセスすると商品名と注文合計金額が表示されている' do
      visit '/orders/ordered'

      expect(page).to have_content 'herb_tea'

      postage = page.find('#postage').text.match(/\d+/).to_s.to_i
      sum     = page.find(:css, '#detail_sum_yen').text.match(/\d+/).to_s.to_i
      expect(sum - postage).to eq 1000
      expect(page).to have_content 1000 + postage
    end

    scenario 'ページにアクセスすると、ユーザーごとの詳細が見れる' do
      visit '/orders/ordered'
      table_of_order_by_user = page.find('.admin_order_table.users_table_in_admin_orders_pages')

      expect(table_of_order_by_user).to have_content 'Alice'
      expect(table_of_order_by_user).to have_content 'herb_tea'
      expect(table_of_order_by_user).to have_content '1000'
    end


    scenario 'ボタンを押すとネスレ発送待ちページに移動して成功メッセージがでる' do
      visit '/orders/ordered'
      click_button 'お茶の受領をシステムに登録'

      expect(page.current_path).to eq '/orders/arrived'
      expect(page).to have_content 'ネスレからお茶が届いたことを登録しました。'
      expect(page).to have_content 'herb_tea'
    end
  end

  context '何も注文されてない時' do
    background do
      create_user_and_login_as 'Alice'

      wait_untill_period_become_out_of_date

      visit '/orders/ordered'
    end

    scenario 'ボタンを押すことができない' do
      expect(page).not_to have_button 'お茶の受領をシステムに登録'
      expect(page).to     have_css    '[type=submit][disabled=disabled]'

      disabled_text = find('[type=submit][disabled=disabled]').value
      expect(disabled_text).to eq 'お茶の受領をシステムに登録'
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
  end
end
