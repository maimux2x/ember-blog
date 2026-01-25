require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "publish" do
    stub_request(:post, "https://pubsubhubbub.appspot.com/")
      .with(
        body: {
          "hub.mode" => "publish",
          "hub.url" => "http://www.example.com/feed"
        },
        headers: { "Content-Type"=>"application/x-www-form-urlencoded" }
      )

    token = JWT.encode({ user_id: users(:alice).id }, Rails.application.secret_key_base)

    post posts_url, **{
      params: { post: { title: "test", body: "Hello World", published_at: "2024-01-01 00:00:00" } },
      headers: { authorization: "Bearer #{token}" }
    }

    assert_response :success
  end
end
