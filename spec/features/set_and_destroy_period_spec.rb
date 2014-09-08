#「期間」「期限」の混在は意図通り。rangeの意味なら「期間」終点の意味なら「期限」を使う。
feature '注文期限を確認、指定、削除する' do
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
      it '今いつまで注文できるかわかる' do
        str =  "現在の注文期間は#{I18n.l Period.singleton_instance.end_time}までです。"
        expect(page).to have_content str #strの位置には式展開文字列を直接かけない。
      end
    end
    context '注文期間が現在を含まないとき' do
      background do
        Period.set_out_of_date_times!
        visit page.current_path
      end
      it '注文期間が過去であることがわかる' do
        str = "注文期間は#{I18n.l Period.singleton_instance.end_time}まででした。"
        expect(page).to have_content str
      end
    end
    context '注文期間自体が設定されていないとき' do
      it { expect(page).to have_content '注文期限が設定されていません。' }
    end
  end
end
