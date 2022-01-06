class Api::V1::AnswersController < ApplicationController
  protect_from_forgery #追記
  before_action :set_target_answer, only: %i[ edit update ]
  before_action :master_user, only: %i[ edit update ] #自分自身でないと操作できないアクション

  #def show
  #end

  def edit
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, status: :created
    else
      render json: { status: 'SUCCESS', message: 'Not updated', data: @answer.errors }
    end
  end

  # def update
  #   @answer_event = Event.find_by(id: @answer.event_id)
  #   if @answer.update(answer_params)
  #     redirect_to group_path(@answer_event.group_id)
  #   else
  # #フォームの入力エラーを起こした際のエラー表示を取得するための処理
  #     redirect_to group_path(@answer.events.group_id), flash: {
  #     answer: @answer,
  #     error_messages: @answer.errors.full_messages
  #   }
  #   end
  # end

private

  def answer_params
    params.require(:answer).permit(:answer)
  end

  def set_target_answer
    @answer = Answer.find(params[:id])
  end

#master_user(自分のアカウント)でないと戻す処理
  def master_user
    #binding.pry
    unless @answer.user_id == current_user.id
      redirect_back(fallback_location: root_path) #直接urlに入力してきたユーザーは戻す
    end
  end

end
