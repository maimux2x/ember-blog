Rails.application.config.after_initialize do
  ActiveStorage::DirectUploadsController.class_eval do
    skip_forgery_protection
  end
end
