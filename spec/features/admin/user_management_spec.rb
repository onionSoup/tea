feature 'ユーザー管理用ページ' do
  let!(:alice) { create(:user, name: 'Alice') }

  background do
    login_as 'Alice'

    click_link '管理者用ページ'
    click_link 'ユーザーの管理'
  end

  context '新ユーザー登録ページにいったとき' do
    background do
      create(:user, name: 'Bob')
      click_link '新ユーザー登録ページ'
    end

    scenario '有効な名前を入力して、ユーザー登録ができる' do
      fill_in 'ユーザー名', with: 'Charlie'
      click_button '登録する'

      expect(page).to have_content 'Charlieを登録しました。'
    end

    scenario '無効な名前を入力した時、ユーザー登録ができない' do
      fill_in 'ユーザー名', with: 'Alice'
      click_button '登録する'
      expect(page).to have_content 'その名前は既に使われています。'

      fill_in 'ユーザー名', with: 'Bob'
      click_button '登録する'
      expect(page).to have_content 'その名前は既に使われています。'

      fill_in 'ユーザー名', with: ''
      click_button '登録する'
      expect(page).to have_content '名前が入力されていません。'
    end
  end
end
