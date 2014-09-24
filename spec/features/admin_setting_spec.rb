feature '管理者になる・ならない設定をする' do
  feature '管理者名が出力されることを確認する' do
    let!(:alice) {create(:user, name: 'Alice')}
    let!(:bob)   {create(:user, name: 'Bob')}

    background do
      Period.set_undefined_times!
      login_as 'Alice'
    end

    context '管理者がいないとき' do
      scenario '@onionSoupを出力しておく' do
        within '#request_to_set_period' do
          expect(page).to have_content '@onionSoup'
        end
      end

      scenario 'ログイン中のAliceが管理者になれて、出力される' do
        click_link '管理者用'
        click_link '管理者の設定'

        select '管理者に設定', from: '設定'
        click_button '保存'

        click_link 'ユーザー用'
        within '#request_to_set_period' do
          expect(page).to have_content 'Alice'
        end
      end
    end
  end
end
