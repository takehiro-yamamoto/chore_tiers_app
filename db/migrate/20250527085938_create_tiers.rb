class CreateTiers < ActiveRecord::Migration[7.1]
  def change
    create_table :tiers do |t|
      t.string :name
      t.string :label
      t.integer :priority

      t.timestamps
    end
  end
end
