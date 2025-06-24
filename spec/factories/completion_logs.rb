FactoryBot.define do
  factory :completion_log do
    completed_at { Time.current }
    note { "メモ" }
    association :user
    association :chore
  end
end