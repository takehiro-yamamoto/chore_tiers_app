class CreateTierListItems < ActiveRecord::Migration[7.1]
  def change
    create_table :tier_list_items do |t|
      t.references :tier_list, null: false, foreign_key: true
      t.references :chore, null: false, foreign_key: true
      t.references :tier, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
