class AdminOrdersController < ApplicationController
  before_action :set_admin_order, only: [:show, :edit, :update, :destroy]

  # GET /admin_orders
  # GET /admin_orders.json
  def index
    @admin_orders = AdminOrder.all
  end

  # GET /admin_orders/1
  # GET /admin_orders/1.json
  def show
  end

  # GET /admin_orders/new
  def new
    @admin_order = AdminOrder.new
  end

  # GET /admin_orders/1/edit
  def edit
  end

  # POST /admin_orders
  # POST /admin_orders.json
  def create
    @admin_order = AdminOrder.new(admin_order_params)

    respond_to do |format|
      if @admin_order.save
        format.html { redirect_to @admin_order, notice: 'Admin order was successfully created.' }
        format.json { render :show, status: :created, location: @admin_order }
      else
        format.html { render :new }
        format.json { render json: @admin_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin_orders/1
  # PATCH/PUT /admin_orders/1.json
  def update
    respond_to do |format|
      if @admin_order.update(admin_order_params)
        format.html { redirect_to @admin_order, notice: 'Admin order was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_order }
      else
        format.html { render :edit }
        format.json { render json: @admin_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_orders/1
  # DELETE /admin_orders/1.json
  def destroy
    @admin_order.destroy
    respond_to do |format|
      format.html { redirect_to admin_orders_url, notice: 'Admin order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_order
      @admin_order = AdminOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_order_params
      params.require(:admin_order).permit(:time_limit_id)
    end
end
