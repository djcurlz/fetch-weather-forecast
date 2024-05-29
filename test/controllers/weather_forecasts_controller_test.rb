require "test_helper"

class WeatherForecastsControllerTest < ActionDispatch::IntegrationTest
  test "show with an input address" do
    address = Faker::Address.full_address
    get weather_forecasts_show_url, params: { address: address }
    assert_response :success
    assert_equal address, session[:address]
  end
end
