class ChangeTierIdToNullableInTierListItems < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tier_list_items, :tier_id, true
  end
end
