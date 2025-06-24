FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    email { Faker::Internet.unique.email }
    password { "password123" }
  end
end
