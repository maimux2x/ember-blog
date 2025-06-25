require "test_helper"

class PostsTest < ActionDispatch::IntegrationTest
  setup do
    stub_request :post, "https://pubsubhubbub.appspot.com/"

    @token = JWT.encode({ user_id: users(:alice).id }, Rails.application.secret_key_base)
  end

  test "GET /api/posts" do
    get "/api/posts"

    assert_conform_schema 200
  end

  test "GET /api/posts/{id}" do
    get "/api/posts/#{posts(:one).id}"

    assert_conform_schema 200
  end

  test "POST /api/posts: Success" do
    post "/api/posts", **{
      as: :json,

      params: {
        post: {
          title:     "blog test",
          body:      "hello, world!",
          tag_names: [ "test" ]
        }
      },

      headers: {
        authorization: "Bearer #{@token}"
      }
    }

    assert_conform_schema 201

    assert_requested :post, "https://pubsubhubbub.appspot.com/", **{
      headers: {
        "Content-Type" => "application/x-www-form-urlencoded"
      },

      body: {
        "hub.mode" => "publish",
        "hub.url"  => "http://www.example.com/feed"
      }
    }
  end

  test "POST /api/posts: Invalid parameters" do
    post "/api/posts", **{
      as: :json,

      params: {
        post: {
          title:     "",
          body:      "",
          tag_names: []
        }
      },

      headers: {
        authorization: "Bearer #{@token}"
      }
    }

    assert_conform_schema(422)

    assert_not_requested :post, "https://pubsubhubbub.appspot.com/"
  end

  test "PATCH /api/posts/{id}: Success" do
    patch "/api/posts/#{posts(:one).id}", **{
      as: :json,

      params: {
        post: {
          title:     "blog test",
          body:      "hello, rails!",
          tag_names: [ "test" ]
        }
      },

      headers: {
        authorization: "Bearer #{@token}"
      }
    }

    assert_conform_schema(200)
  end

  test "PATCH /api/posts/{id}: Invalid parameters" do
    patch "/api/posts/#{posts(:one).id}", **{
      as: :json,

      params: {
        post: {
          title:     "",
          body:      "",
          tag_names: []
        }
      },

      headers: {
        authorization: "Bearer #{@token}"
      }
    }

    assert_conform_schema(422)
  end

  test "DELETE /api/posts/{id}" do
    delete "/api/posts/#{posts(:one).id}", **{
      headers: {
        authorization: "Bearer #{@token}"
      }
    }

    assert_conform_schema(200)
  end
end
