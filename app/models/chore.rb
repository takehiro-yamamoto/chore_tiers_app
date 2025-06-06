class Chore < ApplicationRecord
  belongs_to :tier
  belongs_to :assigned_to, class_name: "User", optional: true

  has_many :completion_logs, dependent: :destroy
end
