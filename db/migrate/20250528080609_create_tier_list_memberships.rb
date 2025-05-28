class CreateTierListMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :tier_list_memberships do |t|
      t.references :tier_list, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      add_index :tier_list_memberships, [:tier_list_id, :user_id], unique: true
      t.timestamps
    end
  end
end
