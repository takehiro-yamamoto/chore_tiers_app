class CreateTierLists < ActiveRecord::Migration[7.1]
  def change
    create_table :tier_lists do |t|
      t.string :name
      t.bigint :creator_id, null: false
      t.index :creator_id
      t.foreign_key :users, column: :creator_id

      t.timestamps
    end
  end
end
