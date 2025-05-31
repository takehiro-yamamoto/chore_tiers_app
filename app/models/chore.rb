class Chore < ApplicationRecord
  belongs_to :tier
  belongs_to :assigned_to

  has_many :completion_logs, dependent: :destroy
end
