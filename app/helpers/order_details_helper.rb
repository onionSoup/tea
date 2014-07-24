module OrderDetailsHelper
  def id_of_p_to_add_details
    @order.order_details.present? ? 'p_to_add_subsequent_details' : 'p_to_add_first_detail'
  end
end
