feature '一般ユーザーがサイドバーで移動する' do
  context 'ログインしていない時' do
    def expect_only_links_of_login_and_new_user
      expect(page).to     have_link 'ログインする'
      expect(page).to     have_link '新規ユーザー登録'
      expect(page).not_to have_link 'ログアウトする'
      expect(page).not_to have_link '注文作成・変更'
      expect(page).not_to have_link '履歴・発送状態'
      expect(page).not_to have_link '管理者用ページ'
    end

    scenario 'ログインページに行くと、ログインとユーザー登録へのリンクがある。' do
      visit new_session_path

      expect_only_links_of_login_and_new_user

      click_link '新規ユーザー登録'
      expect(page.current_path).to eq '/users/new'
    end

    scenario 'ユーザー登録ページに行くと、ログインとユーザー登録へのリンクだけある。' do
      visit new_user_path

      expect_only_links_of_login_and_new_user

      click_link 'ログインする'
      expect(page.current_path).to eq '/sessions/new'
    end
  end

  context 'ログインしている時' do
    background do
      create_user_and_login_as 'Alice'
    end

    def expect_links_for_logged_in_user(expected_link, unexpected_link)
      expect(page).to     have_link 'ログアウトする'
      expect(page).to     have_link '新規ユーザー登録'
      expect(page).to     have_link '管理者用ページ'
      expect(page).to     have_link expected_link
      expect(page).not_to have_link unexpected_link
    end

    context '注文がネスレ公式に発注される前' do
      scenario '注文画面に行くと、履歴・発送状態へのリンクがない' do
        click_link '注文画面'

        expect_links_for_logged_in_user '注文作成・変更', '履歴・発送状態'
      end
    end

    context '注文がネスレ公式に発注された後' do
      scenario '注文履歴画面に行くと、注文作成・変更へのリンクがない' do
        User.find_by(name: 'Alice').order.update_attributes state: 'ordered'
        click_link '管理者用'
        click_link '注文履歴'

        expect_links_for_logged_in_user '履歴・発送状態', '注文作成・変更'
      end
    end
  end
end
