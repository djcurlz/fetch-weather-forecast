class WeatherService
  def initialize
    @api_key = Rails.application.credentials.dig(:openweather, :api_key)
    Rails.logger.info ("WeatherService api_key = #{@api_key}")
  end

  def self.call(latitude, longitude)
    conn = Faraday.new("https://api.openweathermap.org") do |f|
      f.request :json # encode req bodies as JSON and automatically set the Content-Type header
      f.request :retry # retry transient failures
      f.response :json # decode response bodies as JSON
    end    
    response = conn.get('/data/2.5/weather', {
      appid: Rails.application.credentials.dig(:openweather, :api_key),
      lat: latitude,
      lon: longitude,
      units: "metric",
    })
    body = response.body
    Rails.logger.info ("Openweather api response body = #{body}")
    body or raise IOError.new "OpenWeather response body failed"
    body["main"] or raise IOError.new "OpenWeather main section is missing"
    body["main"]["temp"] or raise IOError.new "OpenWeather temperature is missing"
    body["main"]["temp_min"] or raise IOError.new "OpenWeather temperature minimum is missing"
    body["main"]["temp_max"] or raise IOError.new "OpenWeather temperature maximum is missing"
    body["weather"] or raise IOError.new "OpenWeather weather section is missing"
    body["weather"].length > 0 or raise IOError.new "OpenWeather weather section is empty"
    body["weather"][0]["description"] or raise IOError.new "OpenWeather weather description is missing"
    weather = OpenStruct.new
    weather.temperature = body["main"]["temp"]
    weather.temperature_min = body["main"]["temp_min"]
    weather.temperature_max = body["main"]["temp_max"]
    weather.humidity = body["main"]["humidity"]
    weather.wind_speed = body["wind"]["speed"]
    weather.description = body["weather"][0]["description"]
    weather
  end
end
