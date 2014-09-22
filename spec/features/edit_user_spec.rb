feature 'ユーザー名を変更' do
  let!(:alice) { create(:user, name: 'Alice') }
  let!(:bob)   { create(:user, name: 'Bob') }

  context 'ログインしていない時' do
    scenario 'ユーザー名変更画面に行こうとするとログイン画面になる' do
      visit "/users/#{alice.id}/edit"
      expect(page.current_path).to eq '/login'
    end
  end
  context 'ログインしている時' do
    background do
      login_as "Alice"
      click_link 'ユーザー名変更'
    end
    scenario '有効な名前を入力して、ユーザー名の変更ができる' do
      fill_in 'ユーザー名', with: 'Charlie'
      click_button '変更する'

      expect(page).to have_content '名前をCharlieさんに変更しました。'
    end

    scenario '変更前と同じ名前を入力した時は、通知される' do
      fill_in 'ユーザー名', with: 'Alice'
      click_button '変更する'

      expect(page).to have_content '変更前と同じ名前です'
    end

    scenario '既存の名前を入力した時、ユーザー登録ができない' do
      fill_in 'ユーザー名', with: 'Bob'
      click_button '変更する'

      expect(page).to have_content 'その名前は既に使われています。'
    end

    scenario '無効な名前を入力した時、ユーザー登録ができない' do
      fill_in 'ユーザー名', with: ''
      click_button '変更する'

      expect(page).to have_content '名前が入力されていません。'
    end
  end
end
