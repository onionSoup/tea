feature '注文履歴ページ' do
  background do
    alice = create(:user, name: 'Alice')
    herb_tea = create(:item, name: 'herb_tea')
    alice.order.order_details << build(:order_detail, item: herb_tea)

    login_as 'Alice'
  end

  let(:alice) { User.find_by!(name: 'Alice') }

  context 'ネスレ公式にまだ発注してない時' do
    scenario '管理者用ページに来ても、ヘッダーリンクから注文履歴ページにいけない' do
      visit registered_path

      expect(page).to     have_link '注文画面'
      expect(page).not_to have_link '注文履歴'
    end

    scenario 'URL直打ちやブクマからアクセスしても、注文履歴にいけず注文画面にリダイレクト' do
      visit order_path

      expect(page.current_path).to eq '/order/edit'
    end
  end

  context 'ネスレ公式に発注済みの時' do
    context 'お茶が未だ届いていない時' do
      background do
        alice.order.update_attributes state: 'ordered'
      end

      scenario '注文履歴ページに行くと、お茶が未発送であるとわかる。' do
        visit registered_path

        click_link '注文履歴'

        expect(page).to have_content '未発送'
      end
    end

    context 'お茶が支社に届いている時' do
      background do
        alice.order.update_attributes state: 'arrived'
      end

      scenario '注文履歴ページに行くと、お茶が引換可能であるとわかる。' do
        visit registered_path

        click_link '注文履歴'

        expect(page).to have_content '引換可能'
      end
    end

    context 'お茶が引換済みの時' do
      background do
        alice.order.update_attributes state: 'exchanged'
      end

      scenario '注文履歴ページに行くと、お茶が引換済みであるとわかる。' do
        visit registered_path

        click_link '注文履歴'

        expect(page).to have_content '引換済み'
      end
    end
  end
end
