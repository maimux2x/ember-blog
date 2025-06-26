require "test_helper"

class TokensTest < ActionDispatch::IntegrationTest
  test "POST /api/token: Success" do
    post "/api/token", **{
      as: :json,

      params: {
        email:    users(:alice).email,
        password: "password"
      }
    }

    assert_conform_schema(201)
  end

  test "POST /api/token: Invalid credentials" do
    post "/api/token", **{
      as: :json,

      params: {
        email:    "ruby@example.com",
        password: "testtest"
      }
    }

    assert_conform_schema(401)
  end
end
