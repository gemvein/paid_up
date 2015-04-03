class CreateTemplateTable < ActiveRecord::Migration
  def change
    create_table :template do |t|
      t.text :body

      t.timestamps
    end
  end
end
