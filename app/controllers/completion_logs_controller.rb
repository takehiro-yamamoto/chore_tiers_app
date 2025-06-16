class CompletionLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chore

  def create
    @log = @chore.completion_logs.build(log_params)
    @log.user = current_user
    @log.completed_at ||= Time.zone.now # ← ここで未指定なら現在時刻

    if @log.save
      redirect_to request.referer || chore_path(@chore), notice: '完了履歴を登録しました。'
    else
      redirect_to request.referer || chore_path(@chore), alert: '登録に失敗しました。'
    end
  end

  private

  def set_chore
    @chore = Chore.find(params[:chore_id])
  end

  def log_params
    params.fetch(:completion_log, {}).permit(:completed_at, :note)
  end
end
