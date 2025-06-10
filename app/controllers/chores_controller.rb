class ChoresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chore, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
  @tier_lists = current_user&.shared_tier_lists || []
  @selected_tier_list_id = params[:tier_list_id]
  
  if @selected_tier_list_id.present?
    @selected_tier_list = @tier_lists.find_by(id: @selected_tier_list_id)
    @chores = @selected_tier_list&.chores.includes(:assigned_to, :tier)
  else
    # 👇「すべてのティア」のときは、ユーザーが共有されている全ティアリストの家事を表示
    @chores = Chore.joins(:tier_list_items)
                   .where(tier_list_items: { tier_list_id: @tier_lists.pluck(:id) })
                   .includes(:assigned_to, :tier)
  end
  end

  def new
    @chore = Chore.new
    @tier_lists = TierList.where(user: current_user) 
    @tiers = Tier.order(:priority)
    @users = User.order(:name)
  end

  def create
  @chore = current_user.assigned_chores.build(chore_params)

  if @chore.save
    # 👇 tier_id: @chore.tier_id を確実に渡す
    TierListItem.create!(
      chore: @chore,
      tier_list_id: params[:tier_list_id],
      tier_id: @chore.tier_id
    )

    redirect_to edit_tiers_tier_list_path(params[:tier_list_id]), notice: "家事を登録しました。"
  else
    @tier_lists = current_user.shared_tier_lists
    render :new, status: :unprocessable_entity
  end
  end


  def destroy
    @chore = Chore.find(params[:id])
  @chore.destroy
  redirect_to edit_tiers_tier_list_path(@chore.tier_list), notice: "家事を削除しました。"
  end

  def edit
    # 編集画面用に必要なデータを用意
    @tiers = Tier.all.order(:priority)
    @users = User.order(:name)
  end

  def update
    if @chore.update(chore_params)
      redirect_to @chore, notice: "家事を更新しました。"
    else
      # 失敗時は選択肢を再設定して再レンダー
      @tiers = Tier.all.order(:priority)
      @users = User.order(:name)
      flash.now[:alert] = "入力内容に誤りがあります。"
      render :edit
    end
  end

  def show
  @chore = Chore.includes(:tier, :assigned_to, :completion_logs).find(params[:id])
  end


  private

  def set_chore
    @chore = Chore.find(params[:id])
  end

  def chore_params
    params.require(:chore).permit(:title, :description, :tier_id, :assigned_to_id)
  end

  def authorize_user!
    # 例: 作成者か管理者のみ編集可
    unless current_user == @chore.created_by || current_user.admin?
      redirect_to root_path, alert: "権限がありません。"
    end
  end
end