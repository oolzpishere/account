class User::UserViewsController < User::ApplicationController
  before_action :set_user_user_view, only: %i[ show edit update destroy ]

  # GET /user/user_views
  def index
    # @user_user_views = User::UserView.all
  end

  # GET /user/user_views/1
  def show
  end

  # GET /user/user_views/new
  def new
    @user_user_view = User::UserView.new
  end

  # GET /user/user_views/1/edit
  def edit
  end

  # POST /user/user_views
  def create
    @user_user_view = User::UserView.new(user_user_view_params)

    if @user_user_view.save
      redirect_to @user_user_view, notice: "User view was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user/user_views/1
  def update
    if @user_user_view.update(user_user_view_params)
      redirect_to @user_user_view, notice: "User view was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /user/user_views/1
  def destroy
    @user_user_view.destroy
    redirect_to user_user_views_url, notice: "User view was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_user_view
      @user_user_view = User::UserView.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_user_view_params
      params.fetch(:user_user_view, {})
    end
end
