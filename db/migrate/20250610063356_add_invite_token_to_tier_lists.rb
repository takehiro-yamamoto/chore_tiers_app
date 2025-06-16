class AddInviteTokenToTierLists < ActiveRecord::Migration[7.1]
  def change
    add_column :tier_lists, :invite_token, :string, limit: 191
    add_index :tier_lists, :invite_token, unique: true
  end
end
