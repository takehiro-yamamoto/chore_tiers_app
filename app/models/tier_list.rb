class TierList < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :tier_list_items, dependent: :destroy
  has_many :chores, through: :tier_list_items
  has_many :tier_list_memberships, dependent: :destroy
  has_many :members, through: :tier_list_memberships, source: :user

  before_create :generate_invite_token
  after_create :add_creator_to_members
  before_destroy :destroy_linked_chores # ★追加

  validates :name, presence: true, length: { maximum: 30 },
                  uniqueness: { scope: :creator_id, message: 'はすでに登録済みです' }
  validates :creator, presence: true

  private

  def generate_invite_token
    self.invite_token ||= SecureRandom.urlsafe_base64(16)
  end

  def add_creator_to_members
    tier_list_memberships.create!(user: creator) unless members.exists?(id: creator.id)
  end

  def destroy_linked_chores
    # このティアリストに紐づく choreをすべて削除
    chores.each(&:destroy)
  end
end
