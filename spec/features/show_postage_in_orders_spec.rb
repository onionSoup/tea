feature '/ordersで送料を確認する' do
  fixtures :postages

  let!(:alice) {create(:user, name: 'Alice')}
  let!(:bob)   {create(:user, name: 'Bob')}

  let!(:herb_tea) {create(:item, name: 'herb_tea', price: 1000)}
  let!(:red_tea)  {create(:item, name: 'red_tea',  price: 1000)}

  background do
    raise 'must be cost 450, border 4000' unless Postage.postage_cost == 450 && Postage.postage_border == 4000
  end

  feature '注文状況に応じて、送料を計算して表示' do
    context '誰も何も注文していない時にAliceがログインした時' do
      background do
        login_as 'Alice'
      end

      context '誰も何も注文していないとき' do
        it_behaves_like '注文合計金額がsum円である',     sum:   0
        it_behaves_like '注文している人はcount人である', count: 0
        it_behaves_like '１人あたりの送料はprice円',     price: 450
      end

      context 'Aliceが4000円以上注文している時' do
        background do
          alice.order.update_attributes!(order_details: [build(:order_detail, item: herb_tea, quantity: 4)])
          visit page.current_path
        end

        it_behaves_like '注文合計金額がsum円である',     sum:   4000
        it_behaves_like '注文している人はcount人である', count: 1
        it_behaves_like '１人あたりの送料はprice円',     price: 0
      end
    end

    context 'Bobが合計1000円注文している時にAliceがログインした時' do
      background do
        bob.order.update_attributes!(order_details: [build(:order_detail, item: herb_tea, quantity: 1)])
        login_as 'Alice'
      end

      context 'Aliceが注文をまだしていない時' do
        it_behaves_like '注文合計金額がsum円である',     sum:   1000
        it_behaves_like '注文している人はcount人である', count: 1
        it_behaves_like '１人あたりの送料はprice円',     price: 450
      end

      context 'Aliceが1000円分の注文をした時' do
        background do
          alice.order.update_attributes!(order_details: [build(:order_detail, item: herb_tea, quantity: 1)])
          visit page.current_path
        end
        it_behaves_like '注文合計金額がsum円である',     sum:   2000
        it_behaves_like '注文している人はcount人である', count: 2
        it_behaves_like '１人あたりの送料はprice円',     price: (450/2)
      end

      context 'Aliceが3000円分の注文をした時' do
        background do
          alice.order.update_attributes!(order_details: [build(:order_detail, item: herb_tea, quantity: 3)])
          visit page.current_path
        end
        it_behaves_like '注文合計金額がsum円である',     sum:   4000
        it_behaves_like '注文している人はcount人である', count: 2
        it_behaves_like '１人あたりの送料はprice円',     price: 0
      end
    end
  end

  feature '注文期間の状況に応じて、送料変動の可能性を教える' do
    context '注文期間が設定されていないときAliceとしてログイン' do
      background do
        Period.set_undefined_times!
        login_as 'Alice'
      end

      scenario '変動の可能性は無い' do
        within '#postage_change_dialog' do
          expect(page).to have_content '無'
        end
      end
    end

    context '注文期間が期間外の時Aliceとしてログイン' do
      background do
        Period.set_out_of_date_times!
        login_as 'Alice'
      end

      scenario '変動の可能性は無い' do
        within '#postage_change_dialog' do
          expect(page).to have_content '無'
        end
      end
    end

    context '注文期間が期間中の時Aliceとしてログイン' do
      background do
        raise 'period must be include now' unless Period.include_now?
        login_as 'Alice'
      end

      scenario '変動の可能性が有る' do
        within '#postage_change_dialog' do
          expect(page).to have_content '有'
        end
      end
    end
  end
end
