class Chore < ApplicationRecord
  belongs_to :tier, optional: true
  belongs_to :assigned_to, class_name: "User", optional: true

  has_many :completion_logs, dependent: :destroy
  has_many :tier_list_items, dependent: :destroy
end
