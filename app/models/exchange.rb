class Exchange < ActiveRecord::Base
  belongs_to :time_limit
  belongs_to :user
end
