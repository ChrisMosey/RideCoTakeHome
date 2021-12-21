class AddListItemDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :list_items, :checked, false
  end
end
