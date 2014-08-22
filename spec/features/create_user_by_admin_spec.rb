feature '新ユーザーを管理者画面から登録' do
  let!(:alice) { create(:user, name: 'Alice') }

  background do
    login_as 'Alice'

    click_link '管理者用ページ'
    click_link 'ユーザーの管理'
   end

  context '新ユーザー登録ページにいったとき' do
    background do
      create :user, name: 'Bob'

      click_link '新ユーザー登録ページ'
    end

    scenario '有効な名前を入力して、ユーザー登録ができる' do
      fill_in 'ユーザー名', with: 'Charlie'
      click_button '登録する'

      expect(page).to have_content 'Charlieさんを登録しました。'
    end

    scenario '既存の名前を入力した時、ユーザー登録ができない' do
      fill_in 'ユーザー名', with: 'Alice'
      click_button '登録する'

      expect(page).to have_content 'その名前は既に使われています。'
    end

    scenario '既存の名前を入力した時、ログインユーザー以外の名前でも、登録できない' do
      fill_in 'ユーザー名', with: 'Bob'
      click_button '登録する'

      expect(page).to have_content 'その名前は既に使われています。'
    end

    scenario '無効な名前を入力した時、ユーザー登録ができない' do
      fill_in 'ユーザー名', with: ''
      click_button '登録する'

      expect(page).to have_content '名前が入力されていません。'
    end
  end
end
