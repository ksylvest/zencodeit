require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  setup do
    @user = users(:kevin)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create facebook" do
    request.env["omniauth.auth"] = { uid: @user.uid, provider: @user.provider }
    get :create, provider: "facebook"

    assert_not_nil session[:user][:id]
    assert_response :redirect
    assert_redirected_to '/'
  end

  test "should create twitter" do
    request.env["omniauth.auth"] = { uid: @user.uid, provider: @user.provider }
    get :create, provider: "twitter"

    assert_not_nil session[:user][:id]
    assert_response :redirect
    assert_redirected_to '/'
  end

  test "should destroy session" do
    delete :destroy

    assert_nil session[:user][:id]
    assert_response :redirect
    assert_redirected_to '/'
  end

end
