class CreateGroupsTable < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :user_id, index: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
