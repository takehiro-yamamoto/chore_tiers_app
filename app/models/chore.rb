class Chore < ApplicationRecord
  belongs_to :tier, optional: true 
  belongs_to :assigned_to, class_name: "User", optional: true
  belongs_to :creator, class_name: "User", foreign_key: "created_by_id"

  has_many :completion_logs, dependent: :destroy
  has_many :tier_list_items, dependent: :destroy

  # ✅ バリデーション
  validates :title, presence: true, length: { maximum: 20 }
  validates :creator, presence: true
  validates :assigned_to, presence: true
  validates :frequency_type, presence: true

  # ✅ スケジュールに基づいて本日実施すべきかを判定
  def scheduled_for?(date)
    case frequency_type
    when "daily"
      true
    when "weekly"
      return false if frequency_days.blank?

      # "mon", "tue", ..., "sun" に変換して比較
      weekday = date.strftime('%a').downcase
      frequency_days.include?(weekday)
    when "once"
      scheduled_date == date
    else
      false
    end
  end

  # 指定日付に完了しているかどうか（完了履歴ベースで判定）
  def completed_on?(date)
    completion_logs.any? { |log| log.completed_at.to_date == date }
  end

end
