require 'test_helper'

class OutputTest < ActiveSupport::TestCase

  setup do
    @finished = Zencoder::Response.new(code: 200, body: { 'state' => 'finished' })
    @failed = Zencoder::Response.new(code: 200, body: { 'state' => 'failed' })
  end

  test 'refresh success' do
    Output.all.each do |output|
      Zencoder::Output.stubs(:progress).with(output.zencoder_id).returns(@finished)

      output.refresh
      assert_equal output.state, 'finished'
    end
  end

  test 'refresh failure' do
    Output.all.each do |output|
      Zencoder::Output.stubs(:progress).with(output.zencoder_id).returns(@failed)

      output.refresh
      assert_equal output.state, 'failed'
    end
  end

end
