require 'test_helper'

class Account::VideosControllerTest < ActionController::TestCase

  setup do
    @user = users(:kevin)
    @video = videos(:bb)

    @encoding = fixture_file_upload('/videos/encoding.mov')
    @preview = fixture_file_upload('/videos/preview.png')

    Video.any_instance.stubs(:zencodeit).returns({})

    Attached.mock!
    Attached.mock!
    Attached.mock!
  end

  test 'requires authentication' do
    get :index
    assert_redirected_to new_session_path
  end

  test 'should get index' do
    authenticate(@user)

    get :index
    assert_response :success
    assert_not_nil assigns(:videos)
  end

  test 'should get new' do
    authenticate(@user)

    get :new
    assert_response :success
  end

  test 'should create video' do
    authenticate(@user)

    assert_difference('Video.count') do
      post :create, params: { video: { name: @video.name, description: @video.description, encoding: @encoding, preview: @preview } }
    end

    assert_redirected_to account_videos_path
  end

  test 'should get edit' do
    authenticate(@user)

    get :edit, params: { id: @video.id }
    assert_response :success
  end

  test 'should update video' do
    authenticate(@user)

    put :update, params: { id: @video.id, video: { name: @video.name, description: @video.description } }
    assert_redirected_to account_videos_path
  end

  test 'should destroy video' do
    authenticate(@user)

    delete :destroy, params: { id: @video.id }
    assert_redirected_to account_videos_path
  end

private

  def authenticate(user)
    cookies.permanent.signed[:user] = user.id
  end

end
