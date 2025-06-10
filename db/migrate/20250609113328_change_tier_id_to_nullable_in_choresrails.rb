class ChangeTierIdToNullableInChoresrails < ActiveRecord::Migration[7.1]
  def change
    change_column_null :chores, :tier_id, true
  end
end
