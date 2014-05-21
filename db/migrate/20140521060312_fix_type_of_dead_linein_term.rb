class FixTypeOfDeadLineinTerm < ActiveRecord::Migration
  def change
    remove_column :terms, :deadline, :string
    add_column :terms, :deadline, :datetime
  end
end
