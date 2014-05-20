require_relative '20140519080057_add_dead_line_to_term.rb'

class FixupAddDeadLineToTerm < ActiveRecord::Migration
  def change
    revert AddDeadLineToTerm
    add_column :terms, :deadline, :string
  end
end
