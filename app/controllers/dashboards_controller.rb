class DashboardsController < ApplicationController
  # ティア別の完了状況（S〜Dランク単位でカウント）
  TIER_COLORS = {
    "S" => "#ff6b6b",
    "A" => "#ffc04d",
    "B" => "#ffe066",
    "C" => "#70d68a",
    "D" => "#5eb0ef"
  }.freeze

  TIER_ORDER = ["S", "A", "B", "C", "D"]

  before_action :authenticate_user! # ユーザー認証を確認

  def index
    @user = current_user # 現在のユーザーを取得

    # ユーザーが作成/参加しているティアリストを重複なく取得
    @tier_lists = (@user.shared_tier_lists + @user.created_tier_lists).uniq { |t| t.id }

    # 選択中ティアリスト（パラメータ優先／なければ先頭）
    @selected_tier_list = if params[:tier_list_id].present?
      @tier_lists.find { |t| t.id == params[:tier_list_id].to_i }
    else
      @tier_lists.first
    end

    # ティア一覧（並び順はpriority）
    @tiers = Tier.order(:priority)

    # 選択ティアリストの家事のみ
    @chores = @selected_tier_list ? @selected_tier_list.chores : Chore.none

    # ティアごとの家事（カード表示などに）
    @chore_items_by_tier = @selected_tier_list ? @selected_tier_list.chores.includes(:tier).group_by(&:tier_id) : {}

    # サマリー用：総家事数、完了済/未完了数（このティアリストの家事のみ）
    @all_chores_count = @chores.count
    @completed_chores_count = @chores.where(completed: true).count
    @incomplete_chores_count = @chores.where(completed: false).count

    # ---- ティア別分類と完了率 ----
    if @selected_tier_list
      tier_items = @selected_tier_list.tier_list_items.includes(:tier, :chore)
      # ティアごとに家事アイテムをまとめる
      @tier_items_by_rank = tier_items.group_by { |item| item.tier&.label || "未割り当て" }

      # ティアごとの完了統計
      @tier_completion_stats = tier_items
        .select { |item| item.tier.present? }
        .group_by { |item| item.tier }
        .transform_values do |items|
          total = items.count
          completed = items.count { |i| i.chore&.completed? }
          percent = total > 0 ? ((completed.to_f / total) * 100).round(1) : 0.0
          { total: total, completed: completed, percent: percent }
        end

      # ティアごと表示用（色付け・並び替え対応）
      @tier_completion_data = @tier_completion_stats.map do |tier, stats|
        {
          label: tier.label,
          color: TIER_COLORS[tier.label] || "#D2B48C",
          percent: stats[:percent],
          completed: stats[:completed],
          total: stats[:total]
        }
      end
      @tier_completion_data.sort_by! { |data| TIER_ORDER.index(data[:label]) || 99 }
    else
      @tier_items_by_rank = {}
      @tier_completion_stats = {}
      @tier_completion_data = []
    end

    # （全ユーザーの）直近30日の完了ログ数カウント（グラフ用等）
    @completion_stats = CompletionLog
      .where(completed_at: 30.days.ago..Time.current)
      .group(:user_id)
      .count

    # --- カレンダー周辺 ---
    base_date = params[:date].present? ? Date.parse(params[:date]) : Date.current # デフォルトは今日
    view_mode = params[:view] || "month" # "week" or "month"
    @view_mode = view_mode
    @display_date = base_date

    # カレンダーに表示する日付範囲（週/月表示）
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

    # 月表示：月の前後日付も取得
    if view_mode == "month"
      start_day = base_date.beginning_of_month
      end_day = base_date.end_of_month
      first_wday = start_day.wday
      calendar_days = []
      # 前月分
      if first_wday > 0
        prev_month_last_day = start_day - 1
        (first_wday).times do |i|
          calendar_days << prev_month_last_day - (first_wday - 1 - i)
        end
      end
      # 今月
      (start_day..end_day).each { |date| calendar_days << date }
      # 翌月分
      last_wday = end_day.wday
      if last_wday < 6
        (6 - last_wday).times do |i|
          calendar_days << end_day + i + 1
        end
      end
      @calendar_days = calendar_days
    else
      @calendar_days = @calendar_range
    end

    # ---- カレンダー用家事（選択ティアリストのみ） ----
    @calendar_chores = if @selected_tier_list
      @selected_tier_list.chores
        .includes(:assigned_to, :tier)
        .select { |chore| @calendar_range.any? { |d| chore.scheduled_for?(d) } }
    else
      Chore.none
    end


    # ---- 今週の家事（選択ティアリストのみ） ----
    @upcoming_week_range = Date.today.beginning_of_week..Date.today.end_of_week
    @upcoming_chores = if @selected_tier_list
      @selected_tier_list.chores
        .where(created_at: @upcoming_week_range)
        .includes(:assigned_to)
    else
      Chore.none
    end
    @upcoming_count_by_user = @upcoming_chores.group_by(&:assigned_to).transform_values(&:count)

    # ---- ユーザー別完了状況（選択ティアリストのみ） ----
    @user_completion_stats = if @selected_tier_list
    @selected_tier_list.members.includes(:completion_logs).map do |user|
    chores_for_tierlist = @selected_tier_list.chores.where(assigned_to: user)
    completed_count = chores_for_tierlist.where(completed: true).count
    total_count = chores_for_tierlist.count
    percent = total_count > 0 ? ((completed_count.to_f / total_count) * 100).round(1) : 0.0
    [user, { completed: completed_count, total: total_count, percent: percent }]
    end.to_h
    else
    {}
    end

    # 最新完了履歴（5件：グローバル）
    @completion_logs = CompletionLog.includes(:chore, :user)
                                    .order(completed_at: :desc)
                                    .limit(5)

    # カード用サマリー（このティアリストの家事のみ）
    @total_chores = @chores.count
    @completed_chores = @chores.where(completed: true).count
    @incomplete_chores = @chores.where(completed: false).count

    # 以降、必要に応じてダッシュボードに追加処理を書く
  end
end
