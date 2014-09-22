# == Schema Information
#
# Table name: periods
#
#  id         :integer          not null, primary key
#  begin_time :datetime
#  end_time   :datetime
#  created_at :datetime
#  updated_at :datetime
#

describe Period do
  fixtures :items
  let!(:alice) { create(:user, name: 'Alice') }
  let!(:bob)   { create(:user, name: 'Bob') }

  describe '注文期間を期限切れ以外にする' do
    context 'お茶を追加しているユーザーが１人でもいる時' do
      before do
        alice.order.update_attributes!(order_details: [build(:order_detail, item: items(:herb_tea), quantity: 1)])
      end
      it_behaves_like '注文期限を未設定にはできない'
      it_behaves_like '注文期限を現在を含む期間にはできない'
    end

    #Orderがお茶を追加していないユーザーの注文は発注できないことを保証する。（.order_details.empty?ならorder.state.registered?は必ずtrue)
    #そのためPeriodでこれをチェックするのは実は不要。でも、一応確かめておく。
    context '発注した注文が１つでもあるとき' do
      before do
        alice.order.state = 'ordered'
        alice.order.save(validate: false)
      end
      it_behaves_like '注文期限を未設定にはできない'
      it_behaves_like '注文期限を現在を含む期間にはできない'
    end

    context 'お茶を追加しているユーザーが１人もいない時' do
      it '注文期限を未設定にできる' do
        Period.set_undefined_times!
        expect(Period.singleton_instance).to be_valid
      end
      it '注文期限を現在を含む期間にできる' do
        Period.set_one_week_term_include_now!
        expect(Period.singleton_instance).to be_valid
      end
    end
  end

  describe '.end_time_is_tomorrow_or_later?' do
    subject { Period.end_time_is_tomorrow_or_later?(Period.take.end_time) }

    context 'end_timeがJSTで昨日の終わりの時' do
      before do
        Period.singleton_instance.update_attributes!(
          begin_time: Time.zone.now.days_ago(2).in_time_zone('Tokyo').at_beginning_of_day,
          end_time:   Time.zone.now.days_ago(1).in_time_zone('Tokyo').at_end_of_day
          )
      end
      it do
        should be false
      end
    end
    context 'end_timeがJSTで今日の終わりの時' do
      before do
        Period.singleton_instance.update_attributes!(
          begin_time: Time.zone.now.in_time_zone('Tokyo').at_beginning_of_day,
          end_time:   Time.zone.now.in_time_zone('Tokyo').at_end_of_day
          )
      end
      it do
        should be false
      end
    end
    context 'end_timeがJSTで明日の終わりの時' do
      before do
        Period.singleton_instance.update_attributes!(
          begin_time: Time.zone.now.in_time_zone('Tokyo').at_beginning_of_day,
          end_time:   Time.zone.now.tomorrow.in_time_zone('Tokyo').at_end_of_day
          )
      end
      it do
        should be true
      end
    end
    context 'end_timeがJSTで明後日の終わりの時' do
      before do
        Period.singleton_instance.update_attributes!(
          begin_time: Time.zone.now.in_time_zone('Tokyo').at_beginning_of_day,
          end_time:   Time.zone.now.days_since(2).in_time_zone('Tokyo').at_end_of_day
          )
      end
      it do
        should be true
      end
    end
  end
end
