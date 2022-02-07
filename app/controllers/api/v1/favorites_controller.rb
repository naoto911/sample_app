class Api::V1::FavoritesController < ApplicationController
  protect_from_forgery #追記
  before_action :logged_in_user, only: %i[index create destroy] #ログイン後しか実行できない
  before_action :set_target_group, only: %i[index create destroy]
  before_action :set_target_user, only: %i[index create destroy]

  def index
    @favorite = Favorite.where(group_id: @group.id).find_by(user_id: @user.id)
    if @favorite != nil
      @favorite_status = true
    else
      @favorite_status = false
    end
    render json: { favorite_status: @favorite_status, favorite: @favorite }
  end

  def create
    favorite = Favorite.new(favorites_params)
      if favorite.save
        # render json: favorite, status: :created
        render json: {favorite: favorite }
      else
        # render json: favorite.errors, status: :unprocessable_entity
        render json: {favorite: favorite }
      end
  end

  def destroy
    @favorite = Favorite.where(group_id: @group.id).find_by(user_id: @user.id)
    @favorite.destroy
    # render json: { status: 'SUCCESS', message: 'Deleted the favorite', data: @favorite }
    render json: {favorite: @favorite }
  end

private

  def favorites_params
    params.require(:favorite).permit(:group_id, :user_id)
  end

  def set_target_group
    @group = Group.find(params[:group_id])
  end

  def set_target_user
    @user = User.find(current_user.id)
  end

end
