class UsersController < ApplicationController
  def exists
    begin
      user_exists = User.exists?
      render json: { user_exists: user_exists }, status: :ok
    rescue => e
      logger.error "Error checking if user exists: #{e.message}"
      render json: { error: 'There was an error checking if the user exists.' }, status: :internal_server_error
    end
  end
end
