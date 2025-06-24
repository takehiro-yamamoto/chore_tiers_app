FactoryBot.define do
  factory :chore do
    title { "洗濯物たたみ" }
    frequency_type { "daily" }
    association :creator, factory: :user
    association :assigned_to, factory: :user
  end
end
