class Api::V1::GroupsController < ApplicationController
  protect_from_forgery #追記
  before_action :logged_in_user, only: %i[show new edit update destroy join] #ログイン後しか実行できないアクション
  before_action :set_target_group, only: %i[show edit update destroy join]
  before_action :admin_user, only: %i[edit update destroy] #幹事でないと操作できないアクション

  def index
    #--------------------N+1改善ver--------------------
    @groups = Group.includes(:joins).order(id: :asc)
    @groups_length = []
    @groups.each do |group|
      @groups_length << {
        id: group.id, count: group.joins.where(level: '1').length
      }
    end

    #--------------------元々のコード--------------------
    # @groups = Group.order(id: :asc) #idの昇順に表示
    # @groups_length = []
    # Group.preload(:users).all.each do |group|
    #   @groups_length << {
    #     id: group.id, count: group.joins.where(level: '1').length
    #   }
    # end

    # @test = @groups_length2 === @groups_length

    render json: {groups: @groups, current_user: current_user, groups_length: @groups_length }
  end

  def show
    #--------------------N+1改善ver--------------------
    @all_joins = Join.includes(:user).where(group_id: @group.id)

    #Group所属済のuserを取得
    @joins = @all_joins.where(level: '1')

    @admin_user = User.find_by(id: @group.adminuser_id) 
    @users = []
    @joins.each do |join|
        @users.push(join.user)
    end

    #承認中のデータ,user情報を取得
    @approvals = @all_joins - @joins

    @approval_users = []
    @approvals.each do |approval|
      @approval_users.push(approval.user)
    end

    @approval_users_count = @approval_users.length
    # #--------------------元々のコードたち--------------------
    # @all_joins = Join.where(group_id: @group.id)
    
    # #Group所属済のuserを取得
    # @joins = @all_joins.where(level: '1')
    # # @joins = Join.where(group_id: @group.id).where(level: '1')
    # @users = []
    # for @join in @joins do
    #     @user = User.find_by(id: @join.user_id)
    #     @users.push(@user)
    # end
    # @admin_user = User.find_by(id: @group.adminuser_id) 

    # #承認中のデータ,user情報を取得
    # @approvals = @all_joins - @joins
    # # @approvals = Join.where(group_id: @group.id).where(level: '2')
    # @approval_users = []
    # for @approval in @approvals do
    #   @approval_user = User.find_by(id: @approval.user_id)
    #   @approval_users.push(@approval_user)
    # end

    # @test = @approval_users.length == @approval_users2.length

    # render json: {group: @group, users: @users, admin_user: @admin_user, approvals: @approvals, approval_users: @approval_users, current_user: current_user, all_joins: @all_joins }

    render json: {
      group: @group, 
      users: @users, 
      admin_user: @admin_user, 
      approvals: @approvals, 
      approval_users: @approval_users, 
      current_user: current_user, 
      all_joins: @all_joins, 
      joins: @joins, 
      approval_users_count: @approval_users_count
    }
  end

  def new
    @group = Group.new
    render json: {group: @group, current_user: current_user }
  end

  def create
    group = Group.new(group_params)
    current_user = User.find(group.adminuser_id)
    group.users << current_user #group_user_relationsにidを格納させる
    if group.save
      render json: group, status: :created
    else
      render json: group.errors, status: :unprocessable_entity
    end
  end

  def edit
    render json: {group: @group, current_user: current_user, redirect: @redirect }
  end

  def update
    if @group.update(group_params)
      # render json: @group, status: :created
      render json: {group: @group }, status: :created
    else
      render json: { status: 'SUCCESS', message: 'Not updated', data: @group.errors }
    end
  end

  def destroy
    @group.destroy
    render json: { status: 'SUCCESS', message: 'Deleted the post', data: @group }
  end

private

  def group_params
    # params.require(:group).permit(:name,:adminuser_id, :introduction, :image, :image_cache)
    params.require(:group).permit(:image, :image_cache, :name, :frequency, :lat, :lng, :instagram, :introduction,:adminuser_id)
  end

  def set_target_group
    @group = Group.find(params[:id])
  end

  #admin_userでないとrootに戻す処理
  def admin_user
    @redirect = false
    unless @group.adminuser_id == current_user.id
      # redirect_back(fallback_location: root_path) #直接urlに入力してきたユーザーはrootに戻す
      @redirect = true
    end
  end

end
