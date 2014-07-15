feature '注文履歴ページ' do
  background do
    alice = create(:user, name: 'Alice')
    herb_tea = create(:item, name: 'herb_tea')
    alice.order.order_details << build(:order_detail, item: herb_tea)

    login_as 'Alice'
  end

  let(:alice) { User.find_by(name: 'Alice') }

  scenario 'ネスレ公式にまだ発注してない時、注文履歴ページにはいけない' do
    visit ordered_path

    expect(page).to     have_link '注文画面'
    expect(page).not_to have_link '注文履歴'
  end

  context 'ネスレ公式に発注済みの時' do
    scenario 'お茶がまだ届いていない時、注文履歴ページに行くと、お茶が未発送であるとわかる。' do
      alice.order.update_attributes(state: 'ordered')
      visit ordered_path

      click_link '注文履歴'

      expect(page).to have_content '未発送'
    end

    scenario 'お茶が支社に届いている時、注文履歴ページに行くと、お茶が引換可能であるとわかる。' do
      alice.order.update_attributes(state: 'arrived')
      visit ordered_path

      click_link '注文履歴'

      expect(page).to have_content '引換可能'
    end

    scenario 'お茶が引換え済みの時、注文履歴ページに行くと、お茶が引換済みであるとわかる。' do
      alice.order.update_attributes(state: 'exchanged')
      visit ordered_path

      click_link '注文履歴'

      expect(page).to have_content '引換済み'
    end
  end
end
