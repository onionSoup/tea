class Admin::ItemsController < ApplicationController
  def index
    @items = Item.order(:id)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.save!

    redirect_to :admin_items
  rescue ActiveRecord::RecordInvalid => e
    render :new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update_attributes! item_params

    redirect_to :admin_items
  rescue ActiveRecord::RecordInvalid => e
    render :edit
  end

  def destroy
    Item.destroy params[:id]

    redirect_to :admin_items
  end

  private

  def item_params
    params.require(:item).permit(:name, :price)
  end
end
