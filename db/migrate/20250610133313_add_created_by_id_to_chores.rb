class AddCreatedByIdToChores < ActiveRecord::Migration[7.0]
  def change
    add_column :chores, :created_by_id, :bigint
    add_index :chores, :created_by_id
    add_foreign_key :chores, :users, column: :created_by_id

    # 👇 既存の家事に current_user を割り当てることはできないので、とりあえず全て1番目のユーザーに仮割り当て
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE chores SET created_by_id = (
            SELECT id FROM users ORDER BY id ASC LIMIT 1
          )
        SQL
      end
    end
  end
end