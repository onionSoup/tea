feature 'ログアウトする' do
  background do
    create_user_and_login_as 'Alice'
  end

  scenario 'ログインしてるとき、リンクを踏んでログアウトができて、成功メッセージが出る' do
    click_link 'ログアウト'

    expect(page).to have_content 'ログアウトしました'
  end

  scenario 'ログアウトした後は、新規ユーザー登録ページに飛ぶ' do
    click_link 'ログアウト'

    expect(page).to have_content '新規ユーザー登録'
  end
end
