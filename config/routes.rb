Rails.application.routes.draw do
  get 'weather_forecasts/show'

  # Defines the root path route ("/")
  root "weather_forecasts#show"
end
