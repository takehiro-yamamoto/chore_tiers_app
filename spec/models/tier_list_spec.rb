require 'rails_helper'

RSpec.describe TierList, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーションの確認' do
    it 'name, creator があれば有効' do
      tier_list = build(:tier_list, name: 'テストリスト', creator: user)
      expect(tier_list).to be_valid
    end

    it 'name が空だと無効' do
      tier_list = build(:tier_list, name: '', creator: user)
      expect(tier_list).not_to be_valid
      expect(tier_list.errors[:name]).to include('を入力してください')
    end

    it 'name が31文字以上だと無効' do
      tier_list = build(:tier_list, name: 'あ' * 31, creator: user)
      expect(tier_list).not_to be_valid
      expect(tier_list.errors[:name]).to include('は30文字以内で入力してください')
    end

    it 'creator が空だと無効' do
      tier_list = build(:tier_list, name: '掃除リスト', creator: nil)
      expect(tier_list).not_to be_valid
      expect(tier_list.errors[:creator]).to include('を入力してください')
    end

    it '同じユーザーが同名リストを作成すると無効' do
      create(:tier_list, name: 'かぶりリスト', creator: user)
      duplicate = build(:tier_list, name: 'かぶりリスト', creator: user)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include('はすでに登録済みです')
    end
  end
end
