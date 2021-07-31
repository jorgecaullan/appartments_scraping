class ApplicationController < ActionController::Base
  # before_action :authenticate_request

  # def authenticate_request
  #   if request.authorization != ENV['MASTER_PASSWORD']
  #     render json: { error: e.message }, status: 401
  #   end
  # end
end
