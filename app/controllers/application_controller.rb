class ApplicationController < ActionController::API
  private

  def verify_token
    auth_header = request.headers["Authorization"]

    unless auth_header
      return head :unauthorized
    end

    token = auth_header.split(" ").last

    begin
      JWT.decode(token, Rails.application.secret_key_base)
    rescue JWT::DecodeError
      head :forbidden
    end
  end
end
