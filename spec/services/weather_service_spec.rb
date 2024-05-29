require 'rails_helper'

RSpec.describe WeatherService, type: :service do
  before do
    @service = WeatherService.new
  end

  it 'makes a successful WeatherService API request', vcr: {record: :new_episodes} do
    # default value for 4918 Broadmoor Ct Fort Collins CO 80528
    latitude = 40.4784
    longitude = -104.9854
    weather_service_res = WeatherService.call(latitude, longitude)
    puts "weather_service_res = #{weather_service_res.inspect}"
    assert_includes 0..40, weather_service_res.temperature
    assert_includes 0..40, weather_service_res.temperature_min
    assert_includes 0..40, weather_service_res.temperature_max
    assert_includes 0..100, weather_service_res.humidity
    assert_includes 0..100, weather_service_res.wind_speed
    expect(weather_service_res).not_to be_nil
  end
end
