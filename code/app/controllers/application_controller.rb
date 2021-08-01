class ApplicationController < ActionController::Base
  before_action :test_cookie

  private
    def test_cookie
      cookie = request.cookies['master-password']
      redirect_to '/auth' if cookie != ENV['MASTER_PASSWORD']
    end
end
