class TimeLimitsController < ApplicationController
  before_action :set_time_limit, only: [:show, :edit, :update, :destroy]

  # GET /time_limits
  def index
    @time_limits = TimeLimit.all
  end

  # GET /time_limits/1
  def show
  end

  # GET /time_limits/new
  def new
    @time_limit = TimeLimit.new
  end

  # GET /time_limits/1/edit
  def edit
  end

  # POST /time_limits
  def create
    @time_limit = TimeLimit.new(time_limit_params)
    if @time_limit.save
      @time_limit.create_admin_order
      redirect_to @time_limit, notice: 'Time limit was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /time_limits/1
  def update
    if @time_limit.update(time_limit_params)
      redirect_to @time_limit, notice: 'Time limit was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /time_limits/1
  def destroy
    @time_limit.destroy
    redirect_to time_limits_url, notice: 'Time limit was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_limit
      @time_limit = TimeLimit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_limit_params
      params.require(:time_limit).permit(:start, :end, admin_order_attributes:[:id])
    end
end
