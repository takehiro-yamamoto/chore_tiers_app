class TierList < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :tier_list_items, dependent: :destroy
  has_many :chores, through: :tier_list_items
  has_many :tier_list_memberships, dependent: :destroy
  has_many :members, through: :tier_list_memberships, source: :user

  validates :name, presence: true
end