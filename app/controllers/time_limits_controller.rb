class TimeLimitsController < ApplicationController
  before_action :set_time_limit, only: [:show, :edit, :update, :destroy]

  # GET /time_limits
  # GET /time_limits.json
  def index
    @time_limits = TimeLimit.all
  end

  # GET /time_limits/1
  # GET /time_limits/1.json
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
  # POST /time_limits.json
  def create
    @time_limit = TimeLimit.new(time_limit_params)

    respond_to do |format|
      if @time_limit.save
        @time_limit.create_admin_order
        binding.pry
        format.html { redirect_to @time_limit, notice: 'Time limit was successfully created.' }
        format.json { render :show, status: :created, location: @time_limit }
      else
        format.html { render :new }
        format.json { render json: @time_limit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_limits/1
  # PATCH/PUT /time_limits/1.json
  def update
    respond_to do |format|
      if @time_limit.update(time_limit_params)
        format.html { redirect_to @time_limit, notice: 'Time limit was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_limit }
      else
        format.html { render :edit }
        format.json { render json: @time_limit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_limits/1
  # DELETE /time_limits/1.json
  def destroy
    @time_limit.destroy
    respond_to do |format|
      format.html { redirect_to time_limits_url, notice: 'Time limit was successfully destroyed.' }
      format.json { head :no_content }
    end
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
