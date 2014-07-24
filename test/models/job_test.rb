require 'test_helper'

class JobTest < ActiveSupport::TestCase

  setup do
    @finished = Zencoder::Response.new(:code => 200, :body => { 'job' => { 'state' => 'finished' } })
    @failed = Zencoder::Response.new(:code => 200, :body => { 'job' => { 'state' => 'failed' } })
  end

  test "refresh success" do
    Zencoder::Job.stubs(:details).returns(@finished)

    Job.all.each do |job|
      job.refresh
      assert_equal job.state, 'finished'
    end
  end

  test "refresh failure" do
    Zencoder::Job.stubs(:details).returns(@failed)

    Job.all.each do |job|
      job.refresh
      assert_equal job.state, 'failed'
    end
  end

end
