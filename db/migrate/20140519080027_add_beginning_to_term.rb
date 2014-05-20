class AddBeginningToTerm < ActiveRecord::Migration
  def change
    add_column :terms, :beginning, :string
  end
end
