class Admin::ItemsController < ApplicationController
  def index
    @items = Item.includes(:order_details).order(:nestle_index_from_the_top)
  end

  def new
    @item  = Item.new
    @items = Item.all.order(:nestle_index_from_the_top)
  end

  def create
    displace_posteriorly! item_params[:nestle_index_from_the_top]

    @item = Item.create!(item_params)

    be_non_negative_integer!



    redirect_to :admin_items, flash: {success: "#{@item.name}を追加登録しました。"}
  rescue ActiveRecord::RecordInvalid => e
    @item = e.record
    render :new
  end

  def edit
    @item = Item.find(params[:id])
    @items = Item.all.order(:nestle_index_from_the_top)
  end

  def update
    displace_posteriorly! item_params[:nestle_index_from_the_top]

    @item = Item.find(params[:id])
    @item.update_attributes! item_params

    be_non_negative_integer!

    flash[:success] = "#{@item.name}を変更しました。"
    redirect_to :admin_items
  rescue ActiveRecord::RecordInvalid => e
    @item = e.record
    render :edit
  end

  def destroy
    @item = Item.find(params[:id])
    @items = Item.all.order(:nestle_index_from_the_top)

    if @item.can_destroy?
      Item.destroy @item
      be_non_negative_integer!

      flash[:success] = "#{@item.name}を削除しました。"
    else
       flash[:error] = '注文期間中以外なので削除できません。'
    end

    redirect_to :admin_items
  end

  private

  def item_params
    params.require(:item).permit(:name, :price, :nestle_index_from_the_top)
  end

  #挿入位置にあるか、挿入位置より後ろにあるものを１つずつ後ろにずらす
  def displace_posteriorly!(params_inserted_index)
    items_before_insert = Item.all.order(:nestle_index_from_the_top)

    inserted_index = params_inserted_index.to_s.to_i

    items_before_insert.select {|item| item.nestle_index_from_the_top >= inserted_index}.
      each do |target_item|
        target_item.update_attributes!(nestle_index_from_the_top: (target_item.nestle_index_from_the_top + 1))
      end
  end

  #0 1 2.. になるように並び替える
  def be_non_negative_integer!
    items_after_insert = Item.all.order(:nestle_index_from_the_top)

    items_after_insert.each_with_index do |item, i|
      item.update_attributes! nestle_index_from_the_top: i
    end
  end
end
