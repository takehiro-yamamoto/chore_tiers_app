class CreateChores < ActiveRecord::Migration[7.1]
  def change
    create_table :chores do |t|
      t.string :title
      t.text :description
      t.references :tier, null: false, foreign_key: true
      t.references :assigned_to, foreign_key: { to_table: :users } 
      t.boolean :completed

      t.timestamps
    end
  end
end
