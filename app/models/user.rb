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
  has_one :order, dependent: :destroy

  before_create  :create_remember_token
  after_create   :create_order

  validates :name, presence:   true,
                   uniqueness: true,
                   format:     {with: /\A(\S)+\z/, allow_blank: true}

  scope :order_in_state_of, -> (states){
    where(orders: {state: Order.states["#{states}"]})
  }

  scope :has_at_least_one_detail, -> {
    where('EXISTS (SELECT 1 FROM order_details WHERE order_details.order_id = orders.id)')
  }

  scope :latest_admin_user_name ,-> {
    begin
      User.where(admin: true).order('updated_at').last.name
    rescue NoMethodError
      User.none         #nilにするとself.allが返ってしまうっぽい。そこでActiveRecord::Relationの[]を返す。
    end
  }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def admin?
    admin == true
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
