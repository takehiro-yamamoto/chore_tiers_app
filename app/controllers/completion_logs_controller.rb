class CompletionLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chore

  def create
    @log = @chore.completion_logs.build(log_params)
    @log.user = current_user

    if @log.save
      redirect_to chore_path(@chore), notice: '完了履歴を登録しました。'
    else
      flash[:alert] = '登録に失敗しました。'
      redirect_to chore_path(@chore)
    end
  end

  private

  def set_chore
    @chore = Chore.find(params[:chore_id])
  end

  def log_params
    params.require(:completion_log).permit(:completed_at, :note)
  end
end
