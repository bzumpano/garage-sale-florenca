class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.where(admin: true)
  end

  def new
    @user = User.new(admin: true)
  end

  def create
    @user = User.new(user_params)
    @user.admin = true
    if @user.save
      redirect_to admin_users_path, notice: t('flash.admin.created')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: t('flash.admin.updated')
    else
      render :edit
    end
  end

  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: t('flash.admin.self_remove')
    else
      @user.destroy
      redirect_to admin_users_path, notice: t('flash.admin.removed')
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: t('flash.admin.restricted')
    end
  end
end
