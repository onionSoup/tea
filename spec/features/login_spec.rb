feature 'ログインする' do
  scenario '有効な名前を入力して送信ボタンを押すとログインしてユーザー名がでる' do
    User.create(name: 'Bob')

    visit new_session_path
    fill_in 'sessions_name' , :with => 'Bob'

    click_button 'ログイン'

    expect(page).to have_content 'こんにちはBobさん'
  end
  scenario '無効な名前を入力して送信ボタンを押すとログイン失敗メッセージがでる' do
    visit new_session_path
    fill_in 'sessions_name' , :with => 'Bob'

    click_button 'ログイン'

    expect(page).to have_content 'そのユーザは存在しません。新規ユーザー登録してください'
  end
end
