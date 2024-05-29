class WeatherForecastsController < ApplicationController
  def show
    @address_default = "4918 Broadmoor Ct, Fort Collins, Colorado, 80528"
    session[:address] = params[:address]
    if params[:address]
      begin
        @address = params[:address]
        puts "DEBUG: address = #{@address}"
        response = Geocoder.search(@address)
        puts "DEBUG: response = #{response}"
        if response.is_a?(Array) && response.first.is_a?(Geocoder::Result::Base)
          # Process the response
          latitude = response[0].data['properties']['lat'] 
          longitude = response[0].data['properties']['lon'] 
          country_code = response[0].data["properties"]["country_code"]
          postal_code = response[0].data["properties"]["postcode"]
          puts "DEBUG: latitude = #{latitude}"
          puts "DEBUG: longitude = #{longitude}"
          puts "DEBUG: country_code = #{country_code}"
          puts "DEBUG: postal_code = #{postal_code}"
          @weather_cache_key = "#{country_code}/#{postal_code}"
          @weather_cache_pulled = Rails.cache.exist?(@weather_cache_key)
          puts "DEBUG: weather_cache_pulled = #{@weather_cache_pulled}"
          @weather = Rails.cache.fetch(@weather_cache_key, expires_in: 30.minutes) do
            WeatherService.call(latitude, longitude)          
          end
        else
          Rails.logger.error("Invalid response format received: #{response.inspect}")
        end
      rescue => e
        flash.alert = e.message
      end
    end
  end
end
