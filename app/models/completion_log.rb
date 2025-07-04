class CompletionLog < ApplicationRecord
  belongs_to :chore
  belongs_to :user

  validates :completed_at, presence: true # 完了日時は必須
  validates :note, length: { maximum: 100 } # 100文字以内入力可能にする
  validates :chore, presence: true # チェックリストは必須
  validates :user, presence: true # ユーザーは必須
end
