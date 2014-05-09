json.array!(@time_limits) do |time_limit|
  json.extract! time_limit, :id, :start, :end
  json.url time_limit_url(time_limit, format: :json)
end
