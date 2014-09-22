class Admin::ItemsController < ApplicationController
  def index
    @items = Item.includes(:order_details).order(:id)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.create!(item_params)

    redirect_to :admin_items, flash: {success: "#{@item.name}を追加登録しました。"}
  rescue ActiveRecord::RecordInvalid => e
    @item = e.record
    render :new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update_attributes! item_params

    flash[:success] = "#{@item.name}を変更しました。"
    redirect_to :admin_items
  rescue ActiveRecord::RecordInvalid => e
    render :edit
  end

  def destroy
    @item = Item.find(params[:id])

    if @item.can_destroy?
      Item.destroy @item
      flash[:success] = "#{@item.name}を削除しました。"
    else
       flash[:error] = '注文期間中以外なので削除できません。'
    end

    redirect_to :admin_items
  end

  private

  def item_params
    params.require(:item).permit(:name, :price)
  end
end
