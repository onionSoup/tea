describe User do
  it 'has many orders' do
    association = User.reflect_on_association(:orders).macro
    expect(association).to eq(:has_many)
  end

  describe 'validation test' do
    it 'is valid with unique name' do
      expect(User.create(name: 'Smith')).to be_valid
    end

    it 'is invalid without unique name' do
      User.create(name: 'Smith')
      duplicate_user = User.new(name: 'Smith')
      expect(duplicate_user).to be_invalid
    end
  end

  it 'has remember_token by before_create callback' do
    user = User.create(name: 'Smith')
    expect(user.remember_token).to be_a_kind_of(String)
  end
end
