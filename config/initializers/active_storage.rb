Rails.application.config.to_prepare do
  ActiveStorage::DirectUploadsController.class_eval do
    include VerifyToken

    skip_forgery_protection
    before_action :verify_token
  end
end
