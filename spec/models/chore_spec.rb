require 'rails_helper'

RSpec.describe Chore, type: :model do
  let(:user) { FactoryBot.create(:user) }

  context "バリデーションの確認" do
    it "有効な属性を持っていれば有効である" do
      chore = Chore.new(
        title: "掃除",
        frequency_type: "daily",
        creator: user,
        assigned_to: user
      )
      expect(chore).to be_valid
    end

    it "タイトルがないと無効である" do
      chore = Chore.new(
        title: "",
        frequency_type: "daily",
        creator: user,
        assigned_to: user
      )
      expect(chore).not_to be_valid
    end

    it "タイトルが20文字を超えると無効である" do
      chore = Chore.new(
        title: "あ" * 21,
        frequency_type: "daily",
        creator: user,
        assigned_to: user
      )
      expect(chore).not_to be_valid
    end

    it "creatorがないと無効である" do
      chore = Chore.new(
        title: "洗濯",
        frequency_type: "daily",
        assigned_to: user
      )
      expect(chore).not_to be_valid
    end

    it "assigned_toがないと無効である" do
      chore = Chore.new(
        title: "洗濯",
        frequency_type: "daily",
        creator: user
      )
      expect(chore).not_to be_valid
    end

    it "frequency_typeがないと無効である" do
      chore = Chore.new(
        title: "洗濯",
        creator: user,
        assigned_to: user
      )
      expect(chore).not_to be_valid
    end
  end
end

