class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :completion_logs, dependent: :destroy
  has_many :created_tier_lists, class_name: 'TierList', foreign_key: 'creator_id'
  has_many :tier_list_memberships
  has_many :shared_tier_lists, through: :tier_list_memberships, source: :tier_list
  has_many :assigned_chores, class_name: "Chore", foreign_key: "assigned_to_id"
  has_many :created_chores, class_name: "Chore", foreign_key: "created_by_id"

  # ✅ バリデーション
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validate :password_complexity

  private

  def password_complexity
    return if password.blank? || password =~ /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/
    errors.add :password, 'は半角英数字混合で入力してください'
  end

end
