Rails.application.configure do
  litestream_credentials = Rails.application.credentials.litestream

  config.litestream.replica_bucket        = litestream_credentials&.replica_bucket
  config.litestream.replica_key_id        = litestream_credentials&.replica_key_id
  config.litestream.replica_access_key    = litestream_credentials&.replica_access_key
  config.litestream.username              = litestream_credentials&.username
  config.litestream.password              = litestream_credentials&.password
  config.litestream.base_controller_class = "ActionController::Base"
end
