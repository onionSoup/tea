feature '管理者用のダッシュボードページ' do
  feature '注文状況に応じて図を書き換える' do
    fixtures :items

    let!(:alice)   { create(:user, name: 'Alice') }
    let!(:bob)     { create(:user, name: 'Bob') }
    let!(:charlie) { create(:user, name: 'Charlie') }

    before do
      Timecop.freeze(Time.zone.now)

      login_as 'Charlie'
      visit '/admin/dashboard'
    end

    after do
      Timecop.return
    end

    context '注文が未発注の時' do
      context 'お茶を誰かが追加しているとき' do
        background do
          alice.order.update_attributes!(order_details: [build(:order_detail, item: items(:herb_tea), quantity: 1)])
        end
        context '現在、注文期間であるとき' do
          background do
            raise unless Period.include_now?
            visit page.current_path
          end

          it_should_behave_like 'カートの絵はpositionにいる', position: '注文待ち'
          it_should_behave_like '注文の状況の見出しはstateになっている', state: '注文待ち'
        end
        context '現在、注文期間中でないとき' do
          include_context '注文期間がすぎるまで待つ'
          background do
            visit page.current_path
          end

          it_should_behave_like 'カートの絵はpositionにいる', position: '発注'
          it_should_behave_like '注文の状況の見出しはstateになっている', state: '発注'
        end
      end
      context 'お茶を誰も追加していないとき' do
        context '現在、注文期間であるとき' do
          background do
            raise unless Period.include_now?
            visit page.current_path
          end

          it_should_behave_like 'カートの絵はpositionにいる', position: '注文待ち'
          it_should_behave_like '注文の状況の見出しはstateになっている', state: '注文待ち'
        end
        context '現在、注文期間中でないとき' do
          include_context '注文期間がすぎるまで待つ'
          background do
            visit page.current_path
          end

          it_should_behave_like 'カートの絵はpositionにいる', position: '注文なし'
          it_should_behave_like '注文の状況の見出しはstateになっている', state: '注文なし'
        end
        context '注文期間が設定されていないとき' do
          background do
            Period.set_undefined_times!
            visit page.current_path
          end

          it_should_behave_like 'カートの絵はpositionにいる', position: '期間設定'
          it_should_behave_like '注文の状況の見出しはstateになっている', state: '期間設定'
        end
      end
    end

    context '注文を発注済みのとき' do
      background do
        [alice, bob].each do |user|
          user.order.update_attributes!(order_details: [build(:order_detail, item: items(:herb_tea), quantity: 1)])
        end
      end
      include_context '注文期間がすぎるまで待つ'
      include_context 'ネスレ入力用ページに行って、注文を発注する'

      context 'まだお茶が届いていないとき' do
        background do
          visit '/admin/dashboard'
        end

        it_should_behave_like 'カートの絵はpositionにいる', position: '発送待ち'
        it_should_behave_like '注文の状況の見出しはstateになっている', state: '発送待ち'
      end
      context 'お茶が届いたとき' do
        include_context '発送待ち商品確認ページに行って、お茶を受領する'

        background do
          visit '/admin/dashboard'
        end

        it_should_behave_like 'カートの絵はpositionにいる', position: '引換'
        it_should_behave_like '注文の状況の見出しはstateになっている', state: '引換'
      end
      context '届いたお茶を２人中１人だけ引換たとき' do
        include_context '発送待ち商品確認ページに行って、お茶を受領する'
        include_context '引換用ページに行って、userの注文を引換する', user_name: 'Alice'
        background do
          visit '/admin/dashboard'
        end

        it_should_behave_like 'カートの絵はpositionにいる', position: '引換'
        it_should_behave_like '注文の状況の見出しはstateになっている', state: '引換'
      end
      context '届いたお茶を２人中２人引換たとき' do
        include_context '発送待ち商品確認ページに行って、お茶を受領する'
        include_context '引換用ページに行って、userの注文を引換する', user_name: 'Alice'
        include_context '引換用ページに行って、userの注文を引換する', user_name: 'Bob'
        background do
          visit '/admin/dashboard'
        end

        it_should_behave_like 'カートの絵はpositionにいる', position: '終了処理'
        it_should_behave_like '注文の状況の見出しはstateになっている', state: '終了処理'
      end

      context '引換えた後、注文期間を削除した後のとき' do
        include_context '発送待ち商品確認ページに行って、お茶を受領する'
        include_context '引換用ページに行って、userの注文を引換する', user_name: 'Alice'
        include_context '引換用ページに行って、userの注文を引換する', user_name: 'Bob'

        background do
          visit '/admin/period'
          click_button '注文期間を削除する'
          visit '/admin/dashboard'
        end

        it_should_behave_like 'カートの絵はpositionにいる', position: '期間設定'
        it_should_behave_like '注文の状況の見出しはstateになっている', state: '期間設定'
      end
    end
  end
end
