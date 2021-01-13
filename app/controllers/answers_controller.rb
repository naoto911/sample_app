class AnswersController < ApplicationController
  before_action :set_target_answer, only: %i[ edit update ]

  #def show
  #end

  def edit
  end

  def update
    @answer_event = Event.find_by(id: @answer.event_id)
    if @answer.update(answer_params)
      redirect_to group_path(@answer_event.group_id)
    else
  #フォームの入力エラーを起こした際のエラー表示を取得するための処理
      redirect_to group_path(@answer.events.group_id), flash: {
      answer: @answer,
      error_messages: @answer.errors.full_messages
    }
    end
  end

private

  def answer_params
    params.require(:answer).permit(:answer)
  end

  def set_target_answer
    @answer = Answer.find(params[:id])
  end

end
