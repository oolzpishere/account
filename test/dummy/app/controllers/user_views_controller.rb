class UserViewsController < ApplicationController
  before_action :set_user_view, only: [:show, :edit, :update, :destroy]

  # GET /user_views
  def index
    # @user_views = UserView.all
  end

  # GET /user_views/1
  def show
  end

  # GET /user_views/new
  def new
    @user_view = UserView.new
  end

  # GET /user_views/1/edit
  def edit
  end

  # POST /user_views
  def create
    @user_view = UserView.new(user_view_params)

    if @user_view.save
      redirect_to @user_view, notice: 'User view was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user_views/1
  def update
    if @user_view.update(user_view_params)
      redirect_to @user_view, notice: 'User view was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user_views/1
  def destroy
    @user_view.destroy
    redirect_to user_views_url, notice: 'User view was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_view
      @user_view = UserView.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_view_params
      params.fetch(:user_view, {})
    end
end
