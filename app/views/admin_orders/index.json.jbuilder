json.array!(@admin_orders) do |admin_order|
  json.extract! admin_order, :id, :time_limit_id
  json.url admin_order_url(admin_order, format: :json)
end
