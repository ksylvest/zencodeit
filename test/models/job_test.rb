require 'test_helper'

class JobTest < ActiveSupport::TestCase

  setup do
    @finished = Zencoder::Response.new(code: 200, body: { 'job' => { 'state' => 'finished' } })
    @failed = Zencoder::Response.new(code: 200, body: { 'job' => { 'state' => 'failed' } })
  end

  test 'refresh success' do
    Job.all.each do |job|
      Zencoder::Job.stubs(:details).with(job.zencoder_id).returns(@finished)

      job.refresh
      assert_equal job.state, 'finished'
    end
  end

  test 'refresh failure' do
    Job.all.each do |job|
      Zencoder::Job.stubs(:details).with(job.zencoder_id).returns(@failed)

      job.refresh
      assert_equal job.state, 'failed'
    end
  end

end
