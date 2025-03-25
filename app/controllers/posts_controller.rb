class PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    post = Post.new(post_params)
    post.save!
  end

  def update
  end

  def destroy
  end

  private

  def post_params
    params.expect(post: [ :title, :body ])
  end
end
