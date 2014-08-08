feature 'ユーザーを管理者画面から消去する' do
  fixtures :items

  let!(:alice) { create(:user, name: 'Alice') }
  let!(:bob) { create(:user, name: 'Bob') }
  let!(:charlie) { create(:user, name: 'Charlie') }

  background do
      bob.order.update_attributes(
        order_details: [
          build(:order_detail, item: items(:herb_tea), quantity: 1)
        ]
      )

    login_as 'Alice'

    visit '/admin/users'
  end

  scenario 'ページにアクセスした時、ログイン中の自分自身を削除するリンクはない' do
    tr_about_alice = find(".user#{alice.id}")

    expect(tr_about_alice).not_to have_link '削除'
  end

  scenario 'お茶を追加しているユーザーは削除するリンクを押しても、削除できない' do
    within ".user#{bob.id}" do
      click_link '削除'
    end

    expect(page).to have_content 'Bobさんはお茶を注文しているので、削除できません。'
  end

  scenario 'お茶を何も追加していない、かつ自分以外のユーザーなら削除リンクを押せば、削除できる。' do
    within ".user#{charlie.id}" do
      click_link '削除'
    end

    expect(page). to have_content 'Charlieさんを削除しました。'
  end
end
