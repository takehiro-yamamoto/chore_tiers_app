require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションの確認' do
    it '名前・メール・パスワードが正しければ有効' do
      user = build(:user, name: '太郎', email: 'taro@example.com', password: 'abc123')
      expect(user).to be_valid
    end

    it '名前が空だと無効' do
      user = build(:user, name: '', password: 'abc123')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include('を入力してください')
    end

    it '名前が21文字以上だと無効' do
      user = build(:user, name: 'あ' * 21, password: 'abc123')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include('は20文字以内で入力してください')
    end

    it 'メール形式が不正だと無効' do
      user = build(:user, email: 'invalid-email', password: 'abc123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('は不正な値です')
    end

    it 'パスワードが空だと無効' do
      user = build(:user, password: '', password_confirmation: '')
      expect(user).not_to be_valid
    end

    it 'パスワードが6文字未満だと無効' do
      user = build(:user, password: 'a1b2', password_confirmation: 'a1b2')
      expect(user).not_to be_valid
    end

    it 'パスワードが英字のみだと無効' do
      user = build(:user, password: 'abcdef', password_confirmation: 'abcdef')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('は半角英数字混合で入力してください')
    end

    it 'パスワードが数字のみだと無効' do
      user = build(:user, password: '123456', password_confirmation: '123456')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('は半角英数字混合で入力してください')
    end
  end
end
