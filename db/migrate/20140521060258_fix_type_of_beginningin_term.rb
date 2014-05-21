class FixTypeOfBeginninginTerm < ActiveRecord::Migration
  def change
    remove_column :terms, :beginning, :string
    add_column :terms, :beginning, :datetime
  end
end
