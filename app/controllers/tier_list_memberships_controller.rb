class TierListMembershipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @tier_list = TierList.find(params[:tier_list_id])
    user = User.find_by(email: params[:email])

    if user.nil?
      redirect_to edit_tier_list_path(@tier_list), alert: "指定したユーザーが見つかりません。"
    elsif @tier_list.members.include?(user)
      redirect_to edit_tier_list_path(@tier_list), alert: "このユーザーはすでに共有されています。"
    else
      @tier_list.tier_list_memberships.create!(user: user)
      redirect_to edit_tier_list_path(@tier_list), notice: "ユーザーを共有メンバーに追加しました。"
    end
  end

  def destroy
    membership = TierListMembership.find(params[:id])
    tier_list = membership.tier_list
    membership.destroy
    redirect_to edit_tier_list_path(tier_list), notice: "共有メンバーを削除しました。"
  end
end
