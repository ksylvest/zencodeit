require 'test_helper'

class VideoTest < ActiveSupport::TestCase

  setup do
    @processing = Zencoder::Response.new(code: 200, body: { 'id' => '1000', 'outputs' => [ {'id' => '1000'} , {'id' => '1000'}, {'id' => '1000'} ] })
    @failed = Zencoder::Response.new(code: 400)
  end

  test "refresh success" do
    Zencoder::Job.stubs(:create).returns(@processing)

    Video.all.each do |video|
      video.zencodeit
      assert_equal video.state, 'processing'
      assert_not_nil video.job
    end
  end

  test "refresh failure" do
    Zencoder::Job.stubs(:create).returns(@failed)

    Video.all.each do |video|
      video.zencodeit
      assert_equal video.state, 'failed'
    end
  end

end
