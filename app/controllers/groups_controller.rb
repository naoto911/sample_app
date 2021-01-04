class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    group = Group.new(group_params)
    if group.save
      flash[:notice] = "「#{group.name}」を作成しました"
      redirect_to groups_path
    else
      redirect_to new_group_path
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path
    else
      redirect_to :back
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path, flash: { notice: "「#{@group.name}」が削除されました"}
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction)
  end

end
