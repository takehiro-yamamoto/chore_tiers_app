class AddScheduleToChores < ActiveRecord::Migration[7.1]
  def change
    add_column :chores, :frequency_type, :string
    add_column :chores, :frequency_days, :string
    add_column :chores, :frequency_times, :integer
  end
end
