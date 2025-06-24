FactoryBot.define do
  factory :tier_list do
    name { "平日家事リスト" }
    association :creator, factory: :user
  end
end