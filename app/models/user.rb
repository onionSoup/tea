# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  remember_token :string(255)
#

class User < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  before_create :create_remember_token
  #後でi18nを使う必要がある。
  validates :name,  presence: {message: '名前を入力してください。'}, uniqueness: {message: 'その名前は既に使われています。別の名前を入力してください'}

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
