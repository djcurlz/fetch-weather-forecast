require "application_system_test_case"

class WeatherForecastsTest < ApplicationSystemTestCase
  require "application_system_test_case"

  test "show" do
    address = Faker::Address.full_address
    visit url_for \
      controller: "weather_forecasts", 
      action: "show", 
      params: { 
        address: address 
      }
    assert_selector "h1", text: "Fetch My Forecast"
  end

end
