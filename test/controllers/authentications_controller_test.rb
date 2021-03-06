require "test_helper"

class AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get authentications_new_url
    assert_response :success
  end

  test "should get create" do
    get authentications_create_url
    assert_response :success
  end

  test "should get refresh" do
    get authentications_refresh_url
    assert_response :success
  end
end
