require 'test_helper'

class OutputTest < ActiveSupport::TestCase

  setup do
    @finished = Zencoder::Response.new(code: 200, body: { 'state' => 'finished' })
    @failed = Zencoder::Response.new(code: 200, body: { 'state' => 'failed' })
  end

  test "refresh success" do
    Zencoder::Output.stubs(:progress).returns(@finished)

    Output.all.each do |output|
      output.refresh
      assert_equal output.state, 'finished'
    end
  end

  test "refresh failure" do
    Zencoder::Output.stubs(:progress).returns(@failed)

    Output.all.each do |output|
      output.refresh
      assert_equal output.state, 'failed'
    end
  end

end
