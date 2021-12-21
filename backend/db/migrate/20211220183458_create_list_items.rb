class CreateListItems < ActiveRecord::Migration[5.2]
  def change
    create_table :list_items do |t|
      t.string :label
      t.boolean :checked

      t.timestamps
    end
  end
end
