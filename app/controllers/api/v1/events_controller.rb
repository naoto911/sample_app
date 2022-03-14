class Api::V1::EventsController < ApplicationController
  protect_from_forgery #追記
  before_action :logged_in_user, only: %i[new edit update destroy ] #このアクションはログイン後しか実行できない
  before_action :set_target_event, only: %i[show edit update destroy ]
  before_action :set_target_group_id, only: %i[index show new create edit update destroy ]
  before_action :admin_user, only: %i[edit update destroy] #幹事でないと操作できないアクション

  def index
    #--------------------N+1改善ver--------------------
    @events = Event.includes(:answers).where(group_id: @group.id)
    @answers = []
    @events.each do |event|
      @event_answers = event.answers.where(event_id: event.id, user_id: current_user.id)
      @answers += @event_answers
    end

    render json: {events: @events, answers: @answers }

    #--------------------元々のコードたち--------------------
    # @events = Event.where(group_id: @group.id) #groupのeventを全て取得
    # @answers = []
    # for @event in @events do #ひとつずつ確認していく
    #     @event_answers = Answer.where(event_id: @event.id, user_id: current_user.id) #event_idが同じanswerを探す
    #     @answers += @event_answers
    # end

    # render json: {events: @events, answers: @answers }

    #--------------------ここで検証--------------------
    # @bool = false
    # if @events === @events2 && @answers === @answers2
    #   @bool = true
    # end

    # render json: { bool: @bool, 
    #             }

  end

  def show
    #--------------------N+1改善ver--------------------
    @answers = Answer.includes(:user).where(event_id: @event.id)
    @participant_answers= @answers.where("answer = '○'")
    @unparticipant_answers = @answers - @participant_answers

    #参加希望userを取得
    @participant_users = []
    @participant_answers.each do |participant_answer|
        @participant_users.push(participant_answer.user)
    end

    #非参加userを取得
    @unparticipant_users = []
    @unparticipant_answers.each do |unparticipant_answer|
        @unparticipant_users.push(unparticipant_answer.user)
    end

    render json: {group: @group, event: @event, participant_users: @participant_users, unparticipant_users: @unparticipant_users }

    #--------------------元々のコードたち--------------------
    # @answers = Answer.where(event_id: @event.id)
    # @participant_answers= @answers.where("answer = '○'")
    # @unparticipant_answers = @answers - @participant_answers
    # @participant_users = []
    # @unparticipant_users = []
    
    #   for @participant_answer in @participant_answers do
    #       @user = User.find_by(id: @participant_answer.user_id)
    #       @participant_users.push(@user)
    #   end

    #   for @unparticipant_answer in @unparticipant_answers do
    #     @user = User.find_by(id: @unparticipant_answer.user_id)
    #     @unparticipant_users.push(@user)
    #   end

    # render json: {group: @group, event: @event, participant_users: @participant_users, unparticipant_users: @unparticipant_users }

    #--------------------ここで検証--------------------
    # @bool = false
    # if @participant_users === @participant_users2 && @unparticipant_users === @unparticipant_users2
    #   @bool = true
    # end

    # render json: { bool: @bool, 
    #             }

  end

  def new
    @event = Event.new
    #@event = @group.events.new
  end

  def create
    #--------------------N+1改善ver--------------------
    event = Event.new(event_params)
    @group_joins = Join.includes(:user).where(group_id: @group.id).where(level: '1')

    @group_joins.each do |group_join|
      event.users << group_join.user
     end

    if event.save
      render json: {event: event }
    else
      render json: {event: event }
    end

    #--------------------元々のコード--------------------
    # event = Event.new(event_params)
    # @group_joins = @group.joins.where(level: '1')

    # @group_joins.each do |group_join|
    #   event.users << group_join.user
    #  end

    # if event.save
    #   render json: {event: event }
    # else
    #   render json: {event: event }
    # end

  end

  def edit
  end

  def update
    if @event.update(event_params)
      # render json: @event, status: :created
      render json: {event: @event }
    else
      # render json: { status: 'SUCCESS', message: 'Not updated', data: @event.errors }
      render json: {event: @event }
    end
  end

  def destroy
    @event.destroy
    # render json: { status: 'SUCCESS', message: 'Deleted the post', data: @event }
    render json: {event: @event }
  end

private

  def event_params
    params.require(:event).permit(:date, :place, :lat, :lng, :starttime, :finishtime, :remarks).merge(group_id: params[:group_id])
  end

  def set_target_event
    @event = Event.find(params[:event_id])
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

