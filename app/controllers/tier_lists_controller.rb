class TierListsController < ApplicationController
  before_action :set_tier_list, only: [:show, :edit, :update, :edit_tiers, :update_tiers, :destroy]

  def index
    @tier_lists = current_user.shared_tier_lists + current_user.created_tier_lists # すべてのTierListを取得
  end

  def new
    @tier_list = TierList.new # 新しいTierListを作成するためのインスタンスを生成
  end

  def create
    @tier_list = current_user.created_tier_lists.build(tier_list_params) # 現在のユーザーに紐づけて新しいTierListを作成
    if @tier_list.save 
      redirect_to edit_tiers_tier_list_path(@tier_list) # ✅ ティア編集画面に遷移
    else
      render :new # 保存に失敗した場合、新規作成フォームを再表示
    end
  end

  def show
  end

  def edit
  end

  def update
  if @tier_list.update(tier_list_params)
    redirect_to edit_tiers_tier_list_path(@tier_list), notice: "ティアリスト名を更新しました。"
  else
    flash.now[:alert] = "更新に失敗しました。"
    render :edit, status: :unprocessable_entity
  end
  end


  def destroy
  @tier_list.destroy
  redirect_to root_path, notice: "ティアリストを削除しました。"
  end

  def edit_tiers
    @chores = @tier_list.chores # ここで@choresを取得
    @tiers = Tier.all.order(:priority) # すべてのTierを取得し、優先度でソート
    @tier_list_items = @tier_list.tier_list_items.includes(:chore, :tier) # タスクとTierを含むTierListItemsを取得

    @unassigned_chores = @tier_list.tier_list_items 
    .where(tier_id: nil)
    .includes(:chore)
    .map(&:chore)

  end

  def update_tiers
  chore_updates = params[:chore_updates] || []

  ActiveRecord::Base.transaction do 
    chore_updates.each do |update| 
      chore = @tier_list.chores.find(update[:id])
      new_tier_id = update[:tier_id]

      item = TierListItem.find_by(tier_list: @tier_list, chore: chore)

      if item
        item.update!(tier_id: new_tier_id)
      else
        TierListItem.create!(
          tier_list: @tier_list,
          chore: chore,
          tier_id: new_tier_id
        )
      end

      # 🔁 chore.tier_id を同期（表示用に必要なら）
      chore.update!(tier_id: new_tier_id)
    end
  end

  head :ok
rescue ActiveRecord::RecordInvalid => e
  render json: { error: e.message }, status: :unprocessable_entity
end

   def ensure_editable_tier_list
    tier_list = current_user.created_tier_lists.first

    unless tier_list
      tier_list = current_user.created_tier_lists.create!(name: "マイティアリスト")
    end

    redirect_to edit_tiers_tier_list_path(tier_list)
  end
  
  def accept_invite
  if !user_signed_in?
    session[:pending_invite_token] = params[:token]
    redirect_to new_user_session_path, alert: "ログイン後に招待が完了します。"
    return
  end

  @tier_list = TierList.find_by(invite_token: params[:token])

  if @tier_list.nil?
    redirect_to root_path, alert: "招待リンクが無効です。"
    return
  end

  if @tier_list.members.include?(current_user)
    redirect_to edit_tiers_tier_list_path(@tier_list), notice: "すでにこのティアリストに参加しています。"
    return
  end

  @tier_list.tier_list_memberships.create!(user: current_user)
  redirect_to edit_tiers_tier_list_path(@tier_list), notice: "ティアリストに参加しました。"
  end


  private

  def set_tier_list
    @tier_list = TierList.find(params[:id])
  end

  def tier_list_params
    params.require(:tier_list).permit(:name)
  end
end
