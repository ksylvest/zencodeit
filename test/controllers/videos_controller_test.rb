require 'test_helper'

class VideosControllerTest < ActionController::TestCase

  setup do
    @video = videos(:bb)
    @job = jobs(:bb_job)
    @output = outputs(:bb_output_webm)

    Job.any_instance.stubs(:refresh).returns({})
    Output.any_instance.stubs(:refresh).returns({})
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:videos)
  end

  test "should get video" do
    get :show, id: @video.id
    assert_response :success
    assert_not_nil assigns(:video)
  end

  test "should respond to notifications" do
    post :notifications, job: { id: @job.zencoder_id }, output: { id: @output.zencoder_id }, format: :xml
    post :notifications, job: { id: @job.zencoder_id }, output: { id: @output.zencoder_id }, format: :json

    assert_response :success
  end

end
