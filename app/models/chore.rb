class Chore < ApplicationRecord
  belongs_to :tier, optional: true 
  belongs_to :assigned_to, class_name: "User", optional: true
  belongs_to :creator, class_name: "User", foreign_key: "created_by_id"

  has_many :completion_logs, dependent: :destroy
  has_many :tier_list_items, dependent: :destroy
end
