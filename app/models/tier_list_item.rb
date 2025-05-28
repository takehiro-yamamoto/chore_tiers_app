class TierListItem < ApplicationRecord
  belongs_to :tier_list
  belongs_to :chore
  belongs_to :tier

  validates :tier_list_id, :chore_id, :tier_id, presence: true
end
