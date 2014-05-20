# == Schema Information
#
# Table name: exchanges
#
#  id            :integer          not null, primary key
#  exchange_flag :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  time_limit_id :integer
#

class Exchange < ActiveRecord::Base
  belongs_to :time_limit
  scope :false_and_older, -> { joins(:time_limit).where(:exchange_flag => false).order('time_limit.start DESC') }
end
