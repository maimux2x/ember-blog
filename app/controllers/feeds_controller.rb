class FeedsController < ApplicationController
  def show
    @posts = Post.order(id: :desc).includes(:tags).limit(10)
  end
end
