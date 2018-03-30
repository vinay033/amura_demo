require 'github'
class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to :back, :alert => "Access denied."
    end
  end

  def get_repositories
    @user = User.find params[:id]
    @repositories = Github::get_public_repo @user
  end
end
