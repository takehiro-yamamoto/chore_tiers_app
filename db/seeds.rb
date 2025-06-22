# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
tiers = [
  { name: '最高', label: 'S', priority: 1 },
  { name: '高', label: 'A', priority: 2 },
  { name: '中', label: 'B', priority: 3 },
  { name: '低', label: 'C', priority: 4 },
  { name: '最低', label: 'D', priority: 5 }
]

tiers.each do |tier|
  Tier.find_or_create_by!(name: tier[:name]) do |t|
    t.label = tier[:label]   # SCSSクラス名に一致させる
    t.priority = tier[:priority]
  end
end