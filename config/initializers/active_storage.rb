Rails.application.config.after_initialize do
  ActiveStorage::DirectUploadsController.class_eval do
    include VerifyToken

    before_action :verify_token
    skip_forgery_protection
  end
end
