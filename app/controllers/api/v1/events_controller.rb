class Api::V1::EventsController < ApplicationController
  protect_from_forgery #追記
  before_action :logged_in_user, only: %i[new edit update destroy ] #このアクションはログイン後しか実行できない
  before_action :set_target_event, only: %i[show edit update destroy ]
  before_action :set_target_group_id, only: %i[index show new create edit update destroy ]
  before_action :admin_user, only: %i[edit update destroy] #幹事でないと操作できないアクション

  def index
    @events = Event.where(group_id: @group.id)
    render json: {events: @events } #, events: @events, current_user: current_user }
  end

  def show
    @answers = Answer.where(event_id: @event.id)
    render json: {group: @group, event: @event, current_user: current_user,answers: @answers }
  end

  def new
    @event = Event.new
    #@event = @group.events.new
  end

  def create
    event = Event.new(event_params)
    # @group = Group.find(params[:group_id]) #Groupを取得 1/11追記
    event.users << @group.users #Anwserにidを格納させる 1/11追記
    if event.save
      render json: event, status: :created
    else
      render json: event.errors, status: :unprocessable_entity
    end
  #   if event.save
  #     flash[:notice] = "予定を作成しました"
  #     redirect_to group_path(event.group_id)
  #   else
  # #フォームの入力エラーを起こした際のエラー表示を取得するための処理
  #     redirect_to new_group_event_path, flash: {
  #       event: event,
  #       error_messages: event.errors.full_messages
  #     }
  #   end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to group_path(@event.group_id)
    else
  #フォームの入力エラーを起こした際のエラー表示を取得するための処理
      redirect_to edit_group_event_path, flash: {
      event: @event,
      error_messages: @event.errors.full_messages
    }
    end
  end

  def destroy
    @event.destroy
    redirect_to group_path(@group), flash: { notice: "予定が削除されました"}
  end

private

  def event_params
    params.require(:event).permit(:date, :place, :starttime, :finishtime, :remarks).merge(group_id: params[:group_id])
  end

  def set_target_event
    @event = Event.find(params[:id])
  end

  def set_target_group_id
    @group = Group.find(params[:group_id])
  end

  #admin_userでないとrootに戻す処理
  def admin_user
    unless @group.adminuser_id == current_user.id
      redirect_back(fallback_location: root_path) #直接urlに入力してきたユーザーはrootに戻す
    end
  end

end

