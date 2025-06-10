module VerifyToken
  def verify_token
    auth_header = request.headers["Authorization"]

    return head :unauthorized unless auth_header

    token = auth_header.split(" ").last

    begin
      JWT.decode(token, Rails.application.secret_key_base)
    rescue JWT::DecodeError
      head :forbidden
    end
  end
end
