class RemoveOldForeignKeyFromCompletionLogs < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :completion_logs, :chores

    add_foreign_key :completion_logs, :chores, on_delete: :cascade
  end
end
