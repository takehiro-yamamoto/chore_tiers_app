class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :completion_logs, dependent: :destroy
  has_many :created_tier_lists, class_name: 'TierList', foreign_key: 'creator_id'
  has_many :tier_list_memberships
  has_many :shared_tier_lists, through: :tier_list_memberships, source: :tier_list
end
