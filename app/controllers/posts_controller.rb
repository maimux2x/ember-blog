class PostsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { errors: e.record.errors }, status: :unprocessable_content
  end

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    Post.create!(post_params)
    head :created
  end

  def update
    post = Post.find(params[:id])
    post.update!(post_params)
    head :ok
  end

  def destroy
    Post.find(params[:id]).destroy!
    head :ok
  end

  private

  def post_params
    params.expect(post: [ :title, :body ])
  end
end
