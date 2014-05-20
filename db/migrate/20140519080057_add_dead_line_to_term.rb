class AddDeadLineToTerm < ActiveRecord::Migration
  def change
    add_column :terms, :dead_line, :string
  end
end
