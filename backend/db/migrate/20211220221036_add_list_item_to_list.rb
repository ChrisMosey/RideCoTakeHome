class AddListItemToList < ActiveRecord::Migration[5.2]
  def change
    add_reference :list_items, :list, index: true
  end
end
