# == Schema Information
#
# Table name: terms
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  beginning  :datetime
#  deadline   :datetime
#

class Term < ActiveRecord::Base
end
