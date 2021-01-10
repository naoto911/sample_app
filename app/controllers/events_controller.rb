class EventsController < ApplicationController
  before_action :set_target_event, only: %i[show edit update destroy ]

  def index
  end

  def show
    @group = Group.find(params[:group_id])
  end

  def new
    @group = Group.find(params[:group_id])
    @event = Event.new
    #@event = @group.events.new
  end

  def create
    event = Event.new(event_params)
    if event.save
      flash[:notice] = "予定を作成しました"
      redirect_to group_path(event.group_id)
    else
  #フォームの入力エラーを起こした際のエラー表示を取得するための処理
      redirect_to new_group_event_path, flash: {
        event: event,
        error_messages: event.errors.full_messages
      }
    end
  end

  def edit
    @group = Group.find(params[:group_id])
  end

  def update
    @group = Group.find(params[:group_id])
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
    @group = Group.find(params[:group_id])
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

end


