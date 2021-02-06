class JoinsController < ApplicationController
  def new
  end

  def create
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

end
