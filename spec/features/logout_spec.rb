feature 'ログアウトする' do
  background do
    login_as 'Alice'
  end

  scenario 'ログインしてるとき、リンクを踏んでログアウトができて、成功メッセージが出る' do
    click_link 'ログアウト'

    expect(page).to have_content 'ログアウトしました'
  end

  #descriptionが長くなるので、シナリオを分ける
  scenario 'ログアウトした後は、新規ユーザー登録ページに飛ぶ' do
    #backgroundにまとめられるけど、ユーザー目線のシナリオとしてはここに書いたほうがいいと思う。
    click_link 'ログアウト'

    expect(page).to have_content '新規ユーザー登録'
  end
end
