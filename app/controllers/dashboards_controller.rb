class DashboardsController < ApplicationController
  # ティア別の完了状況（S〜Dランク単位でカウント）
      TIER_COLORS = {
      "S" => "#FFB347",
      "A" => "#FFC872",
      "B" => "#FFDAB3",
      "C" => "#FFEBCD",
      "D" => "#FFF5E6"
      }.freeze
  before_action :authenticate_user! # ユーザー認証を確認

  def index
    
    @user = current_user # 現在のユーザーを取得
    @tier_lists = @user.shared_tier_lists + @user.created_tier_lists # ユーザーが作成したティアリストと共有されたティアリストを取得
    
    # ユーザーの家事一覧（自分が担当のもの）
    @tiers = Tier.order(:priority)

    # 担当家事
    @chores = Chore.where(assigned_to: @user)

    # 自分が担当している chore をティア別に分類
    @chore_items_by_tier = Chore.where(assigned_to: @user)
                                .includes(:tier)
                                .group_by(&:tier_id)

    # サマリー用（必要に応じて）
    @all_chores_count = @user.assigned_chores.count
    @completed_chores_count = @user.assigned_chores.where(completed: true).count
    @incomplete_chores_count = @all_chores_count - @completed_chores_count

    # ティアリスト（作成＋共有）
    @tier_lists = @user.created_tier_lists + @user.shared_tier_lists
    @selected_tier_list = @tier_lists.first
    
    
    # ティア別の家事分類
    if @selected_tier_list
      tier_items = @selected_tier_list.tier_list_items.includes(:tier, :chore)

      # ✅ ティア別に家事アイテムをグループ化（表示用）
      @tier_items_by_rank = tier_items.group_by { |item| item.tier.label }

      # ✅ ティア別の完了状況（S〜Dランク単位でカウント）
      @tier_completion_stats = tier_items.group_by { |item| item.tier }.transform_values do |items|
        total = items.count
        completed = items.count { |i| i.chore&.completed? }
        percent = total > 0 ? ((completed.to_f / total) * 100).round(1) : 0.0

        { total: total, completed: completed, percent: percent }
      end
     
      
      # ティア別の完了状況（S〜Dランク単位でカウント）
      @tier_completion_data = @tier_completion_stats.map do |tier, stats|
      {
      label: tier.label,
      color: TIER_COLORS[tier.label] || "#D2B48C",
      percent: stats[:percent],
      completed: stats[:completed],
      total: stats[:total]
      }
      end


    else
      @tier_items_by_rank = {} # nil回避
      @tier_completion_stats = {} # nil回避
      @tier_completion_data = [] # nil回避
    end

    # 担当ユーザーごとの完了数（過去30日）
    @completion_stats = CompletionLog
                          .where(completed_at: 30.days.ago..Time.current)
                          .group(:user_id)
                          .count

    base_date = params[:date].present? ? Date.parse(params[:date]) : Date.current # デフォルトは今日の日付
    view_mode = params[:view] || "month" # "week" or "month" # デフォルトは月表示

    # 月／週表示範囲の計算
    @view_mode = view_mode
    @display_date = base_date

    # カレンダーの範囲を計算
    @calendar_range =
    if view_mode == "week"
      start_day = base_date.beginning_of_week(:sunday)
      end_day = base_date.end_of_week(:sunday)
      (start_day..end_day).to_a
    else
      start_day = base_date.beginning_of_month
    end_day = base_date.end_of_month
    (start_day..end_day).to_a
    end

    # カレンダー表示用（予定家事）
    @calendar_chores = Chore
      .includes(:assigned_to, :tier) # 家事の詳細情報を含める
      .where(created_at: @calendar_range.first.beginning_of_day..@calendar_range.last.end_of_day) # カレンダー範囲内の家事
      .where(assigned_to: current_user) # 自分に割り当てられた家事
    
    # 最新完了履歴（5件）
    @completion_logs = CompletionLog.includes(:chore, :user)
                                    .order(completed_at: :desc)
                                    .limit(5)

    # カード用サマリー
    @total_chores = @chores.count
    @completed_chores = @chores.where(completed: true).count
    @incomplete_chores = @chores.where(completed: false).count
    
    # 今週の家事（作成日ベース）
    @upcoming_week_range = Date.today.beginning_of_week..Date.today.end_of_week
    @upcoming_chores = Chore.where(created_at: @upcoming_week_range)
                        .includes(:assigned_to)
    @upcoming_count_by_user = @upcoming_chores.group_by(&:assigned_to).transform_values(&:count)

    @user_completion_stats = User.includes(:completion_logs).map do |user|
    # 対象ユーザーの完了ログ数（過去30日）
    completed_count = user.completion_logs.where(completed_at: 30.days.ago..Time.current).count
    # 対象ユーザーの全家事数（担当分）
    total_count = Chore.where(assigned_to: user).count
    # 完了率
    percent = total_count > 0 ? ((completed_count.to_f / total_count) * 100).round(1) : 0.0

    [user, { completed: completed_count, total: total_count, percent: percent }]
    end.to_h

  end
end