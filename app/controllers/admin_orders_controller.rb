class AdminOrdersController < ApplicationController
  before_action :set_admin_order, only: [:show, :edit, :update, :destroy]

  # GET /admin_orders
  def index
    @admin_orders = AdminOrder.all
  end

  # GET /admin_orders/1
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
  def create
    @admin_order = AdminOrder.new(admin_order_params)
    if @admin_order.save
      redirect_to @admin_order, notice: 'Admin order was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin_orders/1
  def update
    if @admin_order.update(admin_order_params)
      redirect_to @admin_order, notice: 'Admin order was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin_orders/1
  def destroy
    @admin_order.destroy
    redirect_to admin_orders_url, notice: 'Admin order was successfully destroyed.'
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
