# == Schema Information
#
# Table name: time_limits
#
#  id         :integer          not null, primary key
#  start      :date
#  end        :date
#  created_at :datetime
#  updated_at :datetime
#

class TimeLimit < ActiveRecord::Base
end
