class TokensController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { errors: e.record.errors }, status: :unprocessable_content
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      data  = { user_id: user.id }
      token = JWT.encode(data, Rails.application.secret_key_base)

      render json: { token: }, status: :ok
    else
      head :unauthorized
    end
  end
end
