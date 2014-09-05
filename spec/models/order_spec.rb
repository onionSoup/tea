# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  state      :integer          default(0)
#

describe Order do
  fixtures :items
  let(:herb_tea) { Item.find_by_name! 'herb_tea' }

  it 'is valid with user and order_details' do
    order = build(:order, :buyer) {|order|
      order.order_details.build attributes_for(:order_detail, item: herb_tea)
    }

    expect(order).to be_valid
  end

  it 'is valid without order_details' do
    order = build(:order, :buyer)

    expect(order).to be_valid
  end

  it 'is invalid if not_registered when period is undefined or include_now' do
    not_registered_states = %w(ordered arrived exchanged)
    set_term_methods      = %w(set_undefined_times! set_one_week_term_include_now!)

    not_registered_states.each do |state|
      set_term_methods.each do |method|
        begin
          eval "Period.#{method}"
          order = build(:order, :buyer, state: state)
        rescue ActiveRecord::RecordInvalid => e
          expect(e.record).to be_invalid
        end
      end
    end
  end

  it 'is invalid when order is not_registered and details empty' do
    not_registered_states = %w(ordered arrived exchanged)

    not_registered_states.each do |state|
      begin
        order = build(:order, :buyer, state: state)
        raise 'in this case details must be empty' if order.order_details.present?
      rescue ActiveRecord::RecordInvalid => e
        expect(e.record).to be_invalid
      end
    end
  end
end
