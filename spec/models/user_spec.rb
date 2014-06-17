# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  remember_token :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

describe User do
  it 'has remember_token by before_create callback' do
    user = create(:user, name: 'Smith')
    expect(user.remember_token).to be_a_kind_of String
  end
end
