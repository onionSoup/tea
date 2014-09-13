#TODO これは、すべて使えないかも。。ただ、時間帯移動を書いたものなので、別の見た目を検証するために残すかも
feature '注文画面ページ' do
  feature '注文状態と注文期間によって、表示を適切に変える' do
    fixtures :items

    let(:header) {page.find('header')}
    let(:nav)    {page.find('nav')}

    let!(:alice) { create(:user, name: 'Alice') }

    before do
      Timecop.freeze(Time.zone.now)

      login_as 'Alice'
    end

    after do
      Timecop.return
    end

    context '注文が未発注の時' do
      context 'お茶を追加しているとき' do
        background do
          alice.order.update_attributes!(order_details: [build(:order_detail, item: items(:herb_tea), quantity: 1)])
        end
        context '現在、注文期間であるとき' do
          background do
            raise unless Period.include_now?
            visit page.current_path
          end
        end
        context '現在、注文期間中でないとき' do
          include_context '注文期間がすぎるまで待つ'
          background do
            visit page.current_path
          end
        end
      end
      context 'お茶を追加していないとき' do
        context '現在、注文期間であるとき' do
          background do
            raise unless Period.include_now?
            visit page.current_path
          end
        end
        context '現在、注文期間中でないとき' do
          include_context '注文期間がすぎるまで待つ'
          background do
            visit page.current_path
          end

        end
        context '注文期間が設定されていないとき' do
          background do
            Period.set_undefined_times!
            visit page.current_path
          end

        end
      end
    end

    context '注文を発注済みのとき' do
      background do
        alice.order.update_attributes!(order_details: [build(:order_detail, item: items(:herb_tea), quantity: 1)])
      end
      include_context '注文期間がすぎるまで待つ'
      include_context 'ネスレ入力用ページに行って、注文を発注する'

      context 'まだお茶が届いていないとき' do
        background do
          visit order_path
        end

      end
      context 'お茶が届いたとき' do
        include_context '発送待ち商品確認ページに行って、お茶を受領する'

        background do
          visit order_path
        end

      end
      context '届いたお茶を引換たとき' do
        include_context '発送待ち商品確認ページに行って、お茶を受領する'
        include_context '引換用ページに行って、userの注文を引換する', user_name: 'Alice'
        background do
          visit order_path
        end

      end

      context '引換えた後、注文期間を削除した後のとき' do
        include_context '発送待ち商品確認ページに行って、お茶を受領する'
        include_context '引換用ページに行って、userの注文を引換する', user_name: 'Alice'
        background do
          visit '/admin/period'
          click_button '注文期間を削除する'
          visit order_path
        end

      end
    end
  end
end
