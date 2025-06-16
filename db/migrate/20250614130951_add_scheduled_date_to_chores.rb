class AddScheduledDateToChores < ActiveRecord::Migration[7.1]
  def change
    add_column :chores, :scheduled_date, :date
  end
end
