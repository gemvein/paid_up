class AddActiveColumnToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :active, :boolean, null: false, default: false
    add_index :groups, :active
  end
end
