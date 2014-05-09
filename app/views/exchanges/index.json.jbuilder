json.array!(@exchanges) do |exchange|
  json.extract! exchange, :id, :order_id, :exchange_flag
  json.url exchange_url(exchange, format: :json)
end
