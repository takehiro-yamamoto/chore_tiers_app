class TierListMembership < ApplicationRecord
  belongs_to :tier_list
  belongs_to :user
  validates :tier_list_id, uniqueness: { scope: :user_id }
end
