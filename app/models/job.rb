class Job < ActiveRecord::Base

  belongs_to :video

  validates_uniqueness_of :zencoder_id

  def refresh
    response = Zencoder::Job.details(zencoder_id)
    self.state = response.success? ? response.body['job']['state'] : 'failed'
    response
  end

end
