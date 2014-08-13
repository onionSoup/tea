module OrderDetailsHelper
  def id_of_p_to_add_details(order)
    if order.order_details.present?
      'p_to_add_subsequent_details'
    else
      'p_to_add_first_detail'
    end
  end
end
