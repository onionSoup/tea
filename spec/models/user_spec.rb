describe User do
  it 'has remember_token by before_create callback' do
    user = User.create(name: 'Smith')
    expect(user.remember_token).to be_a_kind_of(String)
  end
end
