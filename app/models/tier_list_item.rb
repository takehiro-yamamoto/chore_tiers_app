class TierListItem < ApplicationRecord
  belongs_to :tier_list
  belongs_to :chore, dependent: :destroy
  belongs_to :tier, optional: true

  validates :tier_list_id, :chore_id, presence: true
end
