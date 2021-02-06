class JoinsController < ApplicationController
  before_action :logged_in_user, only: %i[show new edit update destroy join] #このアクションはログイン後しか実行できない
  before_action :set_target_group, only: %i[show new create edit update destroy join]

  def new
    @join = Join.new
  end

  def create
    join = Join.new(join_params)
    join.user_id = current_user.id
    if join.save
      flash[:notice] = "「参加申請処理」が完了しました"
      redirect_to group_path(@group)
    else
  #フォームの入力エラーを起こした際のエラー表示を取得するための処理
      redirect_to new_group_join_path, flash: {
        join: join,
        error_messages: join.errors.full_messages
      }
    end
  end

  def update
  end

  def show
  end

  def edit
  end

  #グループ参加申請処理
  def permit
    #グループに参加済みの人の処理
    if @group.users.ids.include?(current_user.id) then
      redirect_to group_path(@group), flash: { notice: "#{@group.name}にはすでに参加済みです"}
    #グループに新規参加の人の処理
    else 
      @group.users << current_user #group_user_relationsにidを格納させる
      Event.where(group_id: @group.id).each_with_index do |group_event| #Eventを次々に取得 1/12編集
        group_event.users << current_user #Anserに(event_id,user_id)を紐付ける 1/12追記
      end
      redirect_to group_path(@group), flash: { notice: "「#{current_user.name}が#{@group.name}に参加しました"}
    end
  end 

  def destroy
  end

private

  def join_params
    params.require(:join).permit(:content, :level).merge(group_id: params[:group_id])
  end

  def set_target_group
    @group = Group.find(params[:group_id])
  end

end
