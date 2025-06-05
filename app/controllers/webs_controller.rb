class WebsController < ActionController::Base
  def show
    send_file Rails.root.join("public/index.html"), disposition: "inline"
  end
end
