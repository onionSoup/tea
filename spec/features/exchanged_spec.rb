feature '引換済み商品の確認ページ' do
  fixtures :items

  let!(:alice) { create(:user, name: 'Alice') }
  let!(:bob)   { create(:user, name: 'Bob') }

  context '引換後で、破棄していないお茶があるとき' do
    before do
      wait_untill_period_become_out_of_date

      [alice, bob].each do |user|
        user.order.update_attributes!(
          state: 'exchanged',
          order_details: [
            build(:order_detail, item: items(:herb_tea), quantity: 1),
            build(:order_detail, item: items(:red_tea) , quantity: 9)
          ]
        )
      end

      login_as 'Alice'
    end

    scenario '商品名とユーザー名が表示されている' do
      visit '/orders/exchanged'

      expect(page).to have_content 'herb_tea'
      expect(page).to have_content 'red_tea'
      expect(page).to have_content 'Alice'
    end
  end

  context '引換後として登録されているお茶がないとき' do
    before do
      wait_untill_period_become_out_of_date

      login_as 'Alice'
      visit '/orders/exchanged'
    end

    scenario '該当するユーザーがいないことがわかる' do
      within '.users_table_in_admin_orders_pages' do
        expect(page).to have_content '該当するユーザーがいません'
      end
    end
  end
end
