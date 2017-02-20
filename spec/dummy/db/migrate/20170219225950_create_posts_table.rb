class CreatePostsTable < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :user_id, index: true
      t.string :title
      t.boolean :active, null: false, default: false
      t.timestamps
    end
    add_index :posts, :active
  end
end
