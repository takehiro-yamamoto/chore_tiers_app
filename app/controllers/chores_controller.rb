class ChoresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chore, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def new
    @chore = Chore.new
    @tier_lists = current_user.shared_tier_lists
  end

  def create
    @chore = current_user.assigned_chores.build(chore_params)

    if @chore.save
      TierListItem.create!(
        chore: @chore,
        tier_list_id: params[:tier_list_id],
        tier_id: params[:tier_id]
      )
      redirect_to root_path, notice: "家事を登録しました。"
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