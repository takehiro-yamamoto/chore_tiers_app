class Chore < ApplicationRecord
  belongs_to :tier, optional: true 
  belongs_to :assigned_to, class_name: "User", optional: true
  belongs_to :creator, class_name: "User", foreign_key: "created_by_id"

  has_many :completion_logs, dependent: :destroy
  has_many :tier_list_items, dependent: :destroy
  
  # ✅ スケジュールに基づいて本日実施すべきかを判定
  def scheduled_for?(date)
  return false if frequency_type.blank?

    case frequency_type
    when "daily"
      true
    when "weekly"
      frequency_days&.split(",")&.include?(date.strftime("%a").downcase)
    when "once"
      scheduled_date == date
    else
      false
    end
  end
end
