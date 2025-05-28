class TierListsController < ApplicationController
  before_action :set_tier_list, only: [:show, :edit, :update, :edit_tiers, :update_tiers]

  def index
    @tier_lists = current_user.shared_tier_lists + current_user.created_tier_lists
  end

  def new
    @tier_list = TierList.new
  end

  def create
    @tier_list = current_user.created_tier_lists.build(tier_list_params)
    if @tier_list.save
      redirect_to @tier_list
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def edit_tiers
    # D&D UIに必要な chores と tiers を取得
    @chores = @tier_list.chores
    @tiers = Tier.all.order(:priority)
    @unassigned_chores = @chores.where(tier_id: nil)
  end

  def update_tiers
  chore_updates = params[:chore_updates] || []

  ActiveRecord::Base.transaction do
    chore_updates.each do |update|
      chore = @tier_list.chores.find(update[:id])
      chore.update!(tier_id: update[:tier_id])
    end
  end

  head :ok
  rescue ActiveRecord::RecordInvalid => e
  render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_tier_list
    @tier_list = TierList.find(params[:id])
  end

  def tier_list_params
    params.require(:tier_list).permit(:name)
  end

end
