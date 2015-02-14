json.array!(@stats) do |stat|
  json.extract! stat, :id, :category, :answer, :year, :question, :source, :link
  json.url stat_url(stat, format: :json)
end
