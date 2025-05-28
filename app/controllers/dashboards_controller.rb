class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @tier_lists = @user.shared_tier_lists + @user.created_tier_lists
    @chores = Chore.where(assigned_to: @user)
    # グラフや統計表示用のデータもここで準備
  end
end
