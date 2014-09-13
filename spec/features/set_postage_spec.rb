feature '送料・無料条件ページ' do
  #fixtures :postages
  #本当はrails_helperで作るよりfixturesをすべてのspecに書いたほうが行儀がいいのかもしれないが..

  background do
    create_user_and_login_as 'Alice'
    visit 'admin/postage'
  end

  scenario '送料と無料条件に０以上の数字を入力して保存するボタンを押せば、設定ができる' do
    fill_in '送料',     with: 0
    fill_in '無料条件', with: 0
    click_button '保存する'

    expect(page).to have_content '送料を0円 送料無料条件を0円に設定しました。'

    fill_in '送料',     with: 450
    fill_in '無料条件', with: 4000
    click_button '保存する'

    expect(page).to have_content '送料を450円 送料無料条件を4000円に設定しました。'
  end

  scenario '送料と無料条件に数字を入力しない場合、設定できない' do
    fill_in '送料',     with: ''
    fill_in '無料条件', with: ''
    click_button '保存する'

    expect(page).to have_content '無料条件が入力されていません。 無料条件は数字を入力してください。 送料が入力されていません。 送料は数字を入力してください。'
  end
end
