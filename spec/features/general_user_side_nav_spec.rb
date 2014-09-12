feature '一般ユーザーがサイドバーで移動する' do
  fixtures :items

  context 'ログインしていない時' do
    def expect_only_links_of_login_and_new_user
      expect(page).to     have_link 'ログイン'
      expect(page).to     have_link '新規ユーザー登録'
      expect(page).not_to have_link 'ログアウト'
      expect(page).not_to have_link '注文画面'
    end

    scenario 'ログインページに行くと、ログインとユーザー登録へのリンクがある' do
      visit login_path

      expect_only_links_of_login_and_new_user

      within '#general_user_side_nav' do
        click_link '新規ユーザー登録'
      end

      expect(page.current_path).to eq '/users/new'
    end

    scenario 'ユーザー登録ページに行くと、ログインとユーザー登録へのリンクだけある' do
      visit new_user_path

      expect_only_links_of_login_and_new_user

      within '#general_user_side_nav' do
        click_link 'ログイン'
      end

      expect(page.current_path).to eq '/login'
    end
  end

  context 'ログインしている時' do
    background do
      create_user_and_login_as 'Alice'
    end

    scenario '注文画面へのリンクがある' do
      expect(page).to have_link click_link '注文画面'
    end
  end
end
