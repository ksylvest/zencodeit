require 'test_helper'

class Account::VideosControllerTest < ActionController::TestCase

  setup do
    @user = users(:kevin)
    @video = videos(:bb)

    @encoding = fixture_file_upload("/videos/encoding.mov")
    @preview = fixture_file_upload("/videos/preview.png")

    Video.any_instance.stubs(:zencodeit).returns({})

    Attached.mock!
    Attached.mock!
    Attached.mock!
  end

  test "requires authentication" do
    get :index
    assert_redirected_to new_session_path
  end

  test "should get index" do
    authenticate

    get :index
    assert_response :success
    assert_not_nil assigns(:videos)
  end

  test "should get new" do
    authenticate

    get :new
    assert_response :success
  end

  test "should create video" do
    authenticate

    assert_difference('Video.count') do
      post :create, video: { name: @video.name, description: @video.description, encoding: @encoding, preview: @preview }
    end

    assert_redirected_to account_videos_path
  end

  test "should get edit" do
    authenticate

    get :edit, id: @video.id
    assert_response :success
  end

  test "should update video" do
    authenticate

    put :update, id: @video.id, video: { name: @video.name, description: @video.description }
    assert_redirected_to account_videos_path
  end

  test "should destroy video" do
    authenticate

    delete :destroy, id: @video.id

    assert_redirected_to account_videos_path
  end

private

  def authenticate
    session[:user] = {}
    session[:user][:id] = @user.id
  end

end
