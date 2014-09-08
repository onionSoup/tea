#「期間」「期限」の混在は意図通り。rangeの意味なら「期間」終点の意味なら「期限」を使う。
feature '注文期限を確認、指定、削除する' do
  fixtures :items
  background do
    Period.singleton_instance.destroy
    visit '/admin/period'
  end

  feature '注文期限を確認する' do
    context '注文期間が現在を含むとき' do
      background do
        Period.set_one_week_term_include_now!
        visit page.current_path
      end
      scenario '今いつまで注文できるかわかる' do
        str =  "現在の注文期間は#{I18n.l Period.singleton_instance.end_time}までです。"
        expect(page).to have_content str #strの位置には式展開文字列を直接かけない。
      end
    end
    context '注文期間が現在を含まないとき' do
      background do
        Period.set_out_of_date_times!
        visit page.current_path
      end
      scenario '注文期間が過去であることがわかる' do
        str = "注文期間は#{I18n.l Period.singleton_instance.end_time}まででした。"
        expect(page).to have_content str
      end
    end
    context '注文期間自体が設定されていないとき' do
      background do
        raise 'period should be undefined' unless Period.has_undefined_times?
      end
      scenario { expect(page).to have_content '注文期限が設定されていません。' }
    end
  end

  feature '注文期限を指定する' do
    context '注文期間が現在を含むとき' do
      background do
        Period.set_one_week_term_include_now!
        visit page.current_path
      end

      it_behaves_like '有効な日時を選択して注文期限を設定でき、無効な日時ではできない'
    end

    context '注文期間が現在を含まないとき' do
      background do
        Period.set_out_of_date_times!
        visit page.current_path
      end

      scenario 'セレクタを選択できず、注文期限を変更できない' do
        expect(page).to have_css '[type=submit][disabled=disabled][data=select_date]'
      end
    end

    context '注文期間自体が設定されていないとき' do
      background do
        raise 'period should be undefined' unless Period.has_undefined_times?
      end
      it_behaves_like '有効な日時を選択して注文期限を設定でき、無効な日時ではできない'
    end
  end

  feature '注文期間を削除する' do
    context '注文期間が現在を含むとき' do
      background do
        Period.set_one_week_term_include_now!
        visit page.current_path
      end
      scenario 'ボタンが押せず、削除はできない' do
        expect(page).to have_css '[type=submit][disabled=disabled][data=delete]'
      end
    end

    context 'お茶を注文しているユーザーがいて、注文期間が現在を含まないとき' do
      background do
        Period.set_one_week_term_include_now!
      end

      include_context 'Aliceが登録してherb_teaを注文している'
      include_context '注文期間がすぎるまで待つ'

      background do
        raise 'period must be out_of_date' unless Period.out_of_date?
        visit page.current_path
      end

      scenario 'ボタンが押せず、削除はできない' do
        expect(page).to have_css '[type=submit][disabled=disabled][data=delete]'
      end
    end

    context 'お茶を注文しているユーザーがおらず、注文期間が現在を含まないとき' do
      background do
        Period.set_one_week_term_include_now!
      end

      include_context '注文期間がすぎるまで待つ'

      background do
        raise 'period must be out_of_date' unless Period.out_of_date?
        visit page.current_path
      end

      scenario 'ボタンを押して、注文期間を削除できる' do
        click_button '注文期間を削除'

        expect(page).to have_content '注文期限が設定されていません'
      end
    end

    context '注文期間自体が設定されていないとき' do
      background do
        raise 'period should be undefined' unless Period.has_undefined_times?
      end
      scenario 'ボタンが押せず、削除はできない' do
        expect(page).to have_css '[type=submit][disabled=disabled][data=delete]'
      end
    end
  end
end
