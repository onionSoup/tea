# == Schema Information
#
# Table name: terms
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  beginning  :string(255)
#  deadline   :string(255)
#

class Term < ActiveRecord::Base
end
