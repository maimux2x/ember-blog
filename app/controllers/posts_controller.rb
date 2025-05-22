require "net/http"

class PostsController < ApplicationController
  before_action :verify_token, only: [ :create, :update, :destroy ]

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { errors: e.record.errors }, status: :unprocessable_content
  end

  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).includes(taggings: :tag)
    @posts = @posts.where("title LIKE :query OR body LIKE :query", query: "%#{ActiveRecord::Base.sanitize_sql_like(params[:query])}%") if params[:query]

    @posts = @posts.joins(:tags).where(tags: { name: params[:tag_name] }) if params[:tag_name]
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    Post.create!(post_params)
    publish

    head :created
  end

  def update
    post = Post.find(params[:id])
    post.update!(post_params)
    publish

    head :ok
  end

  def destroy
    Post.find(params[:id]).destroy!
    head :ok
  end

  private

  def post_params
    params.expect(post: [ :title, :body, tag_names: [] ])
  end

  def publish
    return if Rails.env.development?

    uri = URI.parse("https://pubsubhubbub.appspot.com/")
    Net::HTTP.post_form(uri, {
      "hub.mode" => "publish",
      "hub.url"  => feed_url
    })
  end
end
