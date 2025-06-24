require 'rails_helper'

RSpec.describe CompletionLog, type: :model do
  let(:user) { create(:user) }
  let(:chore) { create(:chore, creator: user, assigned_to: user, frequency_type: 'daily') }

  describe 'バリデーションの確認' do
    it 'user, chore, completed_at があれば有効' do
      log = build(:completion_log, user: user, chore: chore, completed_at: Time.current)
      expect(log).to be_valid
    end

    it 'completed_at が空だと無効' do
      log = build(:completion_log, user: user, chore: chore, completed_at: nil)
      expect(log).not_to be_valid
      expect(log.errors[:completed_at]).to include("を入力してください")
    end

    it 'note が101文字だと無効' do
      log = build(:completion_log, user: user, chore: chore, completed_at: Time.current, note: 'あ' * 101)
      expect(log).not_to be_valid
      expect(log.errors[:note]).to include("は100文字以内で入力してください")
    end

    it 'user が空だと無効' do
      log = build(:completion_log, user: nil, chore: chore, completed_at: Time.current)
      expect(log).not_to be_valid
      expect(log.errors[:user]).to include("を入力してください")
    end

    it 'chore が空だと無効' do
      log = build(:completion_log, user: user, chore: nil, completed_at: Time.current)
      expect(log).not_to be_valid
      expect(log.errors[:chore]).to include("を入力してください")
    end
  end
end
