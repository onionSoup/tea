feature '引換用ページ' do
  fixtures :items

  let!(:alice) { create(:user, name: 'Alice') }

  context '該当する注文があるとき' do
    background do
      wait_untill_period_become_out_of_date

      alice.order.update_attributes(
        state: 'arrived',
        order_details: [
          build(:order_detail, item: items(:herb_tea), quantity: 1),
          build(:order_detail, item: items(:red_tea),  quantity: 9)
        ]
      )

      login_as 'Alice'

      visit '/orders/arrived'
    end

    scenario '引換してない商品があるなら、商品名とユーザー名が表示されている' do
      expect(page).to have_content 'herb_tea'
      expect(page).to have_content 'red_tea'
      expect(page).to have_content 'Alice'
    end

    scenario '何もチェックを入れないとき、ボタンを押しても移動しない' do
      click_button '引換の完了をシステムに登録'

      expect(page.current_path).to eq '/orders/arrived'
      expect(page).to have_content 'チェックが入っていません。'
    end

    scenario '注文のチェックを入れて登録ボタンを押す場合、引換済みページに移動して成功メッセージがでる' do
      check "user_#{alice.id}"

      click_button '引換の完了をシステムに登録'

      expect(page.current_path).to eq '/orders/exchanged'
      expect(page).to have_content '引換したことを登録しました。'
      expect(page).to have_content 'Alice'
    end

    scenario 'ユーザーへの通知用フィールドに@付きのユーザー名と合計金額が表示されている' do
      within '#fe_text' do
        expect(page).to have_content '@Alice'
        expect(page).to have_content '1000'
      end
    end
  end

  context '該当する注文がないとき' do
    background do
      login_as 'Alice'

      wait_untill_period_become_out_of_date

      visit '/orders/arrived'
    end

    scenario 'ボタンを押すことができない' do
      expect(page).not_to have_button '引換の完了をシステムに登録'
      expect(page).to     have_css    '[type=submit][disabled=disabled]'

      disabled_text = find('[type=submit][disabled=disabled]').value
      expect(disabled_text).to eq '引換の完了をシステムに登録'
    end

    scenario '表から該当するユーザーがいないことがわかる' do
      within '.arrived_table' do
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
