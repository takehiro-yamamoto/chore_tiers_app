class CreateCompletionLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :completion_logs do |t|
      t.references :chore, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :completed_at
      t.string :note

      t.timestamps
    end
  end
end
