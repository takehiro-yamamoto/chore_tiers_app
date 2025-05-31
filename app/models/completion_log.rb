class CompletionLog < ApplicationRecord
  belongs_to :chore
  belongs_to :user

  validates :completed_at, presence: true
end
