class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  before_action :authenticate_api_key

  private
  def authenticate_api_key
    provided_api_key = request.headers['X-Api-Key']
    expected_api_key = Rails.application.credentials.dig(:api, :key)
    puts ""
    puts "#########################################"
    puts "PROVIDED KEY => #{provided_api_key}"
    puts "#########################################"
    puts ""

    if provided_api_key != expected_api_key
      render json: { error: 'Not Authorized!' }, status: :unauthorized
    end
  end
end
