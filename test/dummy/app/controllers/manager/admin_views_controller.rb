class Manager::AdminViewsController < Manager::ApplicationController
  before_action :set_manager_admin_view, only: %i[ show edit update destroy ]

  # GET /manager/admin_views
  def index
    # @manager_admin_views = Manager::AdminView.all
  end

  # GET /manager/admin_views/1
  def show
  end

  # GET /manager/admin_views/new
  def new
    @manager_admin_view = Manager::AdminView.new
  end

  # GET /manager/admin_views/1/edit
  def edit
  end

  # POST /manager/admin_views
  def create
    @manager_admin_view = Manager::AdminView.new(manager_admin_view_params)

    if @manager_admin_view.save
      redirect_to @manager_admin_view, notice: "Admin view was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /manager/admin_views/1
  def update
    if @manager_admin_view.update(manager_admin_view_params)
      redirect_to @manager_admin_view, notice: "Admin view was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /manager/admin_views/1
  def destroy
    @manager_admin_view.destroy
    redirect_to manager_admin_views_url, notice: "Admin view was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manager_admin_view
      @manager_admin_view = Manager::AdminView.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def manager_admin_view_params
      params.fetch(:manager_admin_view, {})
    end
end
