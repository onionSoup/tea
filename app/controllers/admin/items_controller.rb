class Admin::ItemsController < ApplicationController
  def index
    @items = Item.includes(:order_details).order(:nestle_index_from_the_top)
  end

  def new
    @item = Item.new
    @items = Item.all.order(:nestle_index_from_the_top)
  end

  def create
    @items = Item.all.order(:nestle_index_from_the_top)
    @item = Item.create!(item_params)

    displace_anteriorly! item_params[:nestle_index_from_the_top]
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
    @items = Item.all.order(:nestle_index_from_the_top)
    @item = Item.find(params[:id])
    @item.update_attributes! item_params

    displace_anteriorly! item_params[:nestle_index_from_the_top]
    be_non_negative_integer!

    flash[:success] = "#{@item.name}を変更しました。"
    redirect_to :admin_items
  rescue ActiveRecord::RecordInvalid => e
    @item = e.record
    render :edit
  end

  def destroy
    @items = Item.all.order(:nestle_index_from_the_top)
    @item = Item.find(params[:id])

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

  #挿入する位置にあるか、挿入位置より前にあるものを１つずつ前にずらす
  def displace_anteriorly!(params_inserted_index)
    inserted_index = params_inserted_index.to_s.to_i

    @items.select {|item| item.nestle_index_from_the_top <= inserted_index}.
        reverse_each.with_index do |item, i|
          item.update_attributes! nestle_index_from_the_top: (item.nestle_index_from_the_top - 1 -i)
        end
  end

  #0 1 2 になるように並び替える
  def be_non_negative_integer!
    @items.each_with_index do |item, i|
      item.update_attributes! nestle_index_from_the_top: i
    end
  end
end
