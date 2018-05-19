class AddActiveColumnToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :active, :boolean, null: false, default: false
    add_index :groups, :active
  end
end
